require "date"
require "nokogiri"
require "htmlentities"
require "json"
require "pathname"
require "open-uri"
require "pp"

module Asciidoctor
  module ISO
    module Cleanup
      def textcleanup(text)
        text.gsub(/\s+<fn /, "<fn ")
      end

      def cleanup(xmldoc)
        termdef_cleanup(xmldoc)
        isotitle_cleanup(xmldoc)
        table_cleanup(xmldoc)
        formula_cleanup(xmldoc)
        figure_cleanup(xmldoc)
        ref_cleanup(xmldoc)
        review_note_cleanup(xmldoc)
        normref_cleanup(xmldoc)
        xref_cleanup(xmldoc)
        para_cleanup(xmldoc)
        callout_cleanup(xmldoc)
        origin_cleanup(xmldoc)
        element_name_cleanup(xmldoc)
        xmldoc
      end

      def element_name_cleanup(xmldoc)
        xmldoc.traverse { |n| n.name = n.name.gsub(/_/, "-") }
      end

      def callout_cleanup(xmldoc)
        xmldoc.xpath("//sourcecode").each do |x|
          callouts = x.elements.select { |e| e.name == "callout" }
          annotations = x.elements.select { |e| e.name == "annotation" }
          if callouts.size == annotations.size
            callouts.each_with_index do |c, i|
              c["target"] = UUIDTools::UUID.random_create
              annotations[i]["id"] = c["id"]
            end
          else
            warn "#{x["id"]}: mismatch of callouts and annotations"
          end
        end
      end

      def para_cleanup(xmldoc)
        xmldoc.xpath("//p[not(@id)]").each do |x|
          x["id"] = Utils::anchor_or_uuid
        end
        xmldoc.xpath("//note[not(@id)][not(ancestor::bibitem)]"\
                     "[not(ancestor::table)]").each do |x|
          x["id"] = Utils::anchor_or_uuid
        end
        xmldoc.xpath("//note[@id][ancestor::table]").each do |x|
          x.delete"id"
        end
      end

      def xref_cleanup(xmldoc)
        reference_names(xmldoc)
        xmldoc.xpath("//xref").each do |x|
          #if InlineAnchor::is_refid? x["target"]
          if is_refid? x["target"]
            x.name = "eref"
            x["bibitemid"] = x["target"]
            x["citeas"] = @anchors[x["target"]][:xref]
            x.delete("target")
          else
            x.delete("type")
          end
        end
      end

      def origin_cleanup(xmldoc)
        xmldoc.xpath("//origin").each do |x|
          x["citeas"] = @anchors[x["bibitemid"]][:xref]
          n = x.next_element
          if !n.nil? && n.name == "isosection"
            n.name = "locality"
            n["type"] = "section"
            n.parent = x
          end
        end
      end

      def termdef_warn(text, re, term, msg)
        if re.match? text
          warn "ISO style: #{term}: #{msg}"
        end
      end

      def termdef_style(xmldoc)
        xmldoc.xpath("//term").each do |t|
          para = t.at("./p") or return
          term = t.at("preferred").text
          termdef_warn(para.text, /^(the|a)\b/i, term,
                       "term definition starts with article")
          termdef_warn(para.text, /\.$/i, term,
                       "term definition ends with period")
        end
      end

      def termdef_stem_cleanup(xmldoc)
        xmldoc.xpath("//termdef/p/stem").each do |a|
          if a.parent.elements.size == 1
            # para containing just a stem expression
            t = Nokogiri::XML::Element.new("admitted", xmldoc)
            parent = a.parent
            t.children = a.remove
            parent.replace(t)
          end
        end
      end

      def termdomain_cleanup(xmldoc)
        xmldoc.xpath("//p/domain").each do |a|
          prev = a.parent.previous
          prev.next = a.remove
        end
      end

      def termdefinition_cleanup(xmldoc)
        xmldoc.xpath("//term").each do |d|
          first_child = d.at("./p | ./figure | ./formula") or return
          t = Nokogiri::XML::Element.new("definition", xmldoc)
          first_child.replace(t)
          t << first_child.remove
          d.xpath("./p | ./figure | ./formula").each do |n|
            t << n.remove
          end
        end
      end

      def termdef_unnest_cleanup(xmldoc)
        # release termdef tags from surrounding paras
        nodes = xmldoc.xpath("//p/admitted | //p/deprecates")
        while !nodes.empty?
          nodes[0].parent.replace(nodes[0].parent.children)
          nodes = xmldoc.xpath("//p/admitted | //p/deprecates")
        end
      end

      def termdef_cleanup(xmldoc)
        termdef_unnest_cleanup(xmldoc)
        termdef_stem_cleanup(xmldoc)
        termdomain_cleanup(xmldoc)
        termdefinition_cleanup(xmldoc)
        termdef_style(xmldoc)
      end

      def isotitle_cleanup(xmldoc)
        # Remove italicised ISO titles
        xmldoc.xpath("//isotitle").each do |a|
          if a.elements.size == 1 && a.elements[0].name == "em"
            a.children = a.elements[0].children
          end
        end
      end

      def dl_table_cleanup(xmldoc)
        # move Key dl after table footer
        q = "//table/following-sibling::*[1]"\
          "[self::p and normalize-space() = 'Key']"
        xmldoc.xpath(q).each do |s|
          if !s.next_element.nil? && s.next_element.name == "dl"
            s.previous_element << s.next_element.remove
            s.remove
          end
        end
      end

      def header_rows_cleanup(xmldoc)
        q = "//table[@headerrows]"
        xmldoc.xpath(q).each do |s|
          thead = s.at("./thead")
          [1..s["headerrows"].to_i].each do
            row = s.at("./tbody/tr")
            row.parent = thead
          end
          s.delete("headerrows")
        end
      end

      def table_cleanup(xmldoc)
        dl_table_cleanup(xmldoc)
        notes_table_cleanup(xmldoc)
        header_rows_cleanup(xmldoc)
      end

      def notes_table_cleanup(xmldoc)
        # move notes into table
        nomatches = false
        until nomatches
          q = "//table/following-sibling::*[1][self::note]"
          nomatches = true
          xmldoc.xpath(q).each do |n|
            n.previous_element << n.remove
            nomatches = false
          end
        end
      end

      def formula_cleanup(x)
        # include where definition list inside stem block
        q = "//formula/following-sibling::*[1]"\
          "[self::p and text() = 'where']"
        x.xpath(q).each do |s|
          if !s.next_element.nil? && s.next_element.name == "dl"
            s.previous_element << s.next_element.remove
            s.remove
          end
        end
      end

      # include footnotes inside figure
      def figure_footnote_cleanup(xmldoc)
        nomatches = false
        until nomatches
          q = "//figure/following-sibling::*[1][self::p and *[1][self::fn]]"
          nomatches = true
          xmldoc.xpath(q).each do |s|
            s.previous_element << s.first_element_child.remove
            s.remove
            nomatches = false
          end
        end
      end

      def figure_dl_cleanup(xmldoc)
        # include key definition list inside figure
        q = "//figure/following-sibling::*"\
          "[self::p and normalize-space() = 'Key']"
        xmldoc.xpath(q).each do |s|
          if !s.next_element.nil? && s.next_element.name == "dl"
            s.previous_element << s.next_element.remove
            s.remove
          end
        end
      end

      def subfigure_cleanup(xmldoc)
        # examples containing only figures become subfigures of figures
        nodes = xmldoc.xpath("//example/figure")
        while !nodes.empty?
          nodes[0].parent.name = "figure"
          nodes = xmldoc.xpath("//example/figure")
        end
      end

      def figure_cleanup(xmldoc)
        figure_footnote_cleanup(xmldoc)
        figure_dl_cleanup(xmldoc)
        subfigure_cleanup(xmldoc)
      end

      def ref_cleanup(xmldoc)
        # move ref before p
        xmldoc.xpath("//p/ref").each do |r|
          parent = r.parent
          parent.previous = r.remove
        end
        xmldoc
      end

      def review_note_cleanup(xmldoc)
        xmldoc.xpath("//review").each do |n|
          prev = n.previous_element
          if !prev.nil? && prev.name == "p"
            n.parent = prev
          end
        end
      end

      def normref_cleanup(xmldoc)
        q = "//references[title = 'Normative References']"
        r = xmldoc.at(q)
        r.elements.each do |n|
          unless ["title", "bibitem"].include? n.name
            n.remove
          end
        end
      end

      def format_ref(ref, isopub)
        return "ISO #{ref}" if isopub
        return "[#{ref}]" if /^\d+$/.match?(ref) && !/^\[.*\]$/.match?(ref) 
        ref
      end

      def reference_names(xmldoc)
        xmldoc.xpath("//bibitem").each do |ref|
          isopub = ref.at(("./publisher/affiliation[name = 'ISO']"))
          docid = ref.at(("./docidentifier"))
          date = ref.at(("./publisherdate"))
          reference = format_ref(docid.text, isopub)
          reference += ": #{date.text}" if date && isopub
          @anchors[ref["id"]] = { xref: reference }
        end
      end

    end
  end
end