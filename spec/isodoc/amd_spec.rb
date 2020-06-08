require "spec_helper"

RSpec.describe IsoDoc do
  it "cross-references notes in amendments" do
    expect(xmlpp(IsoDoc::Iso::HtmlConvert.new({}).convert("test", <<~"INPUT", true))).to be_equivalent_to xmlpp(<<~"OUTPUT")
    <iso-standard xmlns="http://riboseinc.com/isoxml">
    <bibdata> <ext> <doctype>amendment</doctype> </ext> </bibdata>
    <preface>
    <foreword>
    <p>
    <xref target="N"/>
    <xref target="note1"/>
    <xref target="note2"/>
    <xref target="AN"/>
    <xref target="Anote1"/>
    <xref target="Anote2"/>
    </p>
    </foreword>
    </preface>
    <sections>
    <clause id="scope"><title>Scope</title>
    <note id="N">
  <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
</note>
<p><xref target="N"/></p>

    </clause>
    <terms id="terms"/>
    <clause id="widgets"><title>Widgets</title>
    <clause id="widgets1">
    <note id="note1">
  <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
</note>
    <note id="note2">
  <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83a">These results are based on a study carried out on three different types of kernel.</p>
</note>
<p>    <xref target="note1"/> <xref target="note2"/> </p>

    </clause>
    </clause>
    </sections>
    <annex id="annex1">
    <clause id="annex1a">
    <note id="AN">
  <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
</note>
    </clause>
    <clause id="annex1b">
    <note id="Anote1">
  <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
</note>
    <note id="Anote2">
  <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83a">These results are based on a study carried out on three different types of kernel.</p>
</note>
    </clause>
    </annex>
    </iso-standard>
    INPUT
    #{HTML_HDR}
    <br/>
               <div>
                 <h1 class="ForewordTitle">Foreword</h1>
                 <p>
           <a href="#N">[N]</a>
           <a href="#note1">[note1]</a>
           <a href="#note2">[note2]</a>
           <a href="#AN">A.1, Note</a>
           <a href="#Anote1">A.2, Note 1</a>
           <a href="#Anote2">A.2, Note 2</a>
           </p>
               </div>
               <p class="zzSTDTitle1"/>
               <div id="scope">
                 <h1>Scope</h1>
                 <div id="N" class="Note">
                   <p><span class="note_label">NOTE</span>&#160; These results are based on a study carried out on three different types of kernel.</p>
                 </div>
                 <p>
                   <a href="#N">[n]</a>
                 </p>
               </div>
               <div id="terms"><h1/>
       </div>
               <div id="widgets">
                 <h1>Widgets</h1>
                 <div id="widgets1"><span class='zzMoveToFollowing'><b/></span>
           <div id="note1" class="Note"><p><span class="note_label">NOTE</span>&#160; These results are based on a study carried out on three different types of kernel.</p></div>
           <div id="note2" class="Note"><p><span class="note_label">NOTE</span>&#160; These results are based on a study carried out on three different types of kernel.</p></div>
       <p>    <a href="#note1">[note1]</a> <a href="#note2">[note2]</a> </p>

           </div>
               </div>
               <br/>
               <div id="annex1" class="Section3">
               <h1 class='Annex'>
               <b>Annex A</b>
  <br/>
  (informative)
  <br/>
  <br/>
  <b/>
</h1>
                 <div id="annex1a"><span class='zzMoveToFollowing'><b>A.1&#160; </b></span>
           <div id="AN" class="Note"><p><span class="note_label">NOTE</span>&#160; These results are based on a study carried out on three different types of kernel.</p></div>
           </div>
                 <div id="annex1b"><span class='zzMoveToFollowing'><b>A.2&#160; </b></span>
           <div id="Anote1" class="Note"><p><span class="note_label">NOTE 1</span>&#160; These results are based on a study carried out on three different types of kernel.</p></div>
           <div id="Anote2" class="Note"><p><span class="note_label">NOTE 2</span>&#160; These results are based on a study carried out on three different types of kernel.</p></div>
           </div>
               </div>
             </div>
           </body>
       </html>
    OUTPUT
  end

  it "cross-references sections" do
    expect(xmlpp(IsoDoc::Iso::HtmlConvert.new({}).convert("test", <<~"INPUT", true))).to be_equivalent_to xmlpp(<<~"OUTPUT")
      <iso-standard xmlns="http://riboseinc.com/isoxml">
    <bibdata> <ext> <doctype>amendment</doctype> </ext> </bibdata>
      <preface>
      <foreword obligation="informative">
         <title>Foreword</title>
         <p id="A">This is a preamble
         <xref target="C"/>
         <xref target="C1"/>
         <xref target="D"/>
         <xref target="H"/>
         <xref target="I"/>
         <xref target="J"/>
         <xref target="K"/>
         <xref target="L"/>
         <xref target="M"/>
         <xref target="N"/>
         <xref target="O"/>
         <xref target="P"/>
         <xref target="Q"/>
         <xref target="Q1"/>
         <xref target="Q2"/>
         <xref target="R"/>
         </p>
       </foreword>
        <introduction id="B" obligation="informative"><title>Introduction</title><clause id="C" inline-header="false" obligation="informative">
         <title>Introduction Subsection</title>
       </clause>
       <clause id="C1" inline-header="false" obligation="informative">Text</clause>
       </introduction></preface><sections>
       <clause id="D" obligation="normative">
         <title>Scope</title>
         <p id="E">Text</p>
       </clause>

       <clause id="M" inline-header="false" obligation="normative"><title>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
         <title>Introduction</title>
       </clause>
       <clause id="O" inline-header="false" obligation="normative">
         <title>Clause 4.2</title>
       </clause></clause>

       </sections><annex id="P" inline-header="false" obligation="normative">
         <title>Annex</title>
         <clause id="Q" inline-header="false" obligation="normative">
         <title>Annex A.1</title>
         <clause id="Q1" inline-header="false" obligation="normative">
         <title>Annex A.1a</title>
         </clause>
       </clause>
              <appendix id="Q2" inline-header="false" obligation="normative">
         <title>An Appendix</title>
       </appendix>
       </annex><bibliography><references id="R" obligation="informative" normative="true">
         <title>Normative References</title>
       </references><clause id="S" obligation="informative">
         <title>Bibliography</title>
         <references id="T" obligation="informative" normative="false">
         <title>Bibliography Subsection</title>
       </references>
       </clause>
       </bibliography>
       </iso-standard>
    INPUT
        #{HTML_HDR}
    <br/>
    <div>
    <h1 class="ForewordTitle">Foreword</h1>
    <p id="A">This is a preamble
                     <a href='#C'>[C]</a>
                 <a href='#C1'>[C1]</a>
                 <a href='#D'>[D]</a>
                 <a href='#H'>[H]</a>
                 <a href='#I'>[I]</a>
                 <a href='#J'>[J]</a>
                 <a href='#K'>[K]</a>
                 <a href='#L'>[L]</a>
                 <a href='#M'>[M]</a>
                 <a href='#N'>[N]</a>
                 <a href='#O'>[O]</a>
                 <a href='#P'>Annex A</a>
                 <a href='#Q'>A.1</a>
                 <a href='#Q1'>A.1.1</a>
                 <a href='#Q2'>Annex A, Appendix 1</a>
                 <a href='#R'>[R]</a>
    </p>
    </div>
    <br/>
                 <div class="Section3" id="B">
                 <h1 class="IntroTitle">Introduction</h1>
               <div id="C">
                 <h1>Introduction Subsection</h1>
        </div>
        <div id="C1"><span class='zzMoveToFollowing'>
  <b/>
</span>
Text</div>
             </div>
    <p class="zzSTDTitle1"/>
    <div id="D">
    <h1>Scope</h1>
      <p id="E">Text</p>
    </div>
    <div>
    <h1>Normative references</h1>
    </div>
               <div id="M">
                 <h1>Clause 4</h1>
                 <div id="N">
          <h1>Introduction</h1>
        </div>
                 <div id="O">
          <h1>Clause 4.2</h1>
        </div>
               </div>
               <br/>
               <div id="P" class="Section3">
                 <h1 class="Annex"><b>Annex A</b><br/>(normative)<br/><br/><b>Annex</b></h1>
                 <div id="Q">
          <h2>A.1&#160; Annex A.1</h2>
          <div id="Q1">
          <h3>A.1.1&#160; Annex A.1a</h3>
          </div>
        </div>
       <div id="Q2">
        <h2>Appendix 1&#160; An Appendix</h2>
        </div>
               </div>
               <br/>
               <div>
                 <h1 class="Section3">Bibliography</h1>
                 <div>
                   <h2 class="Section3">Bibliography Subsection</h2>
                 </div>
               </div>
             </div>
           </body>
       </html>
    OUTPUT
  end

    it "processes section names" do
    expect(xmlpp(IsoDoc::Iso::HtmlConvert.new({}).convert("test", <<~"INPUT", true))).to be_equivalent_to xmlpp(<<~"OUTPUT")
      <iso-standard xmlns="http://riboseinc.com/isoxml">
    <bibdata> <ext> <doctype>amendment</doctype> </ext> </bibdata>
      <boilerplate>
        <copyright-statement>
        <clause>
          <title>Copyright</title>
        </clause>
        </copyright-statement>
        <license-statement>
        <clause>
          <title>License</title>
        </clause>
        </license-statement>
        <legal-statement>
        <clause>
          <title>Legal</title>
        </clause>
        </legal-statement>
        <feedback-statement>
        <clause>
          <title>Feedback</title>
        </clause>
        </feedback-statement>
      </boilerplate>
      <preface>
      <abstract obligation="informative">
         <title>Foreword</title>
      </abstract>
      <foreword obligation="informative">
         <title>Foreword</title>
         <p id="A">This is a preamble</p>
       </foreword>
        <introduction id="B" obligation="informative"><title>Introduction</title><clause id="C" inline-header="false" obligation="informative">
         <title>Introduction Subsection</title>
       </clause>
       </introduction>
       <clause id="B1"><title>Dedication</title></clause>
       <clause id="B2"><title>Note to reader</title></clause>
       <acknowledgements obligation="informative">
         <title>Acknowledgements</title>
       </acknowledgements>
        </preface><sections>
       <clause id="D" obligation="normative">
         <title>Scope</title>
         <p id="E">Text</p>
       </clause>

       <clause id="M" inline-header="false" obligation="normative"><title>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
         <title>Introduction</title>
       </clause>
       <clause id="O" inline-header="false" obligation="normative">
         <title>Clause 4.2</title>
       </clause>
       <clause id="O1" inline-header="false" obligation="normative">
       </clause>
        </clause>

       </sections><annex id="P" inline-header="false" obligation="normative">
         <title>Annex</title>
         <clause id="Q" inline-header="false" obligation="normative">
         <title>Annex A.1</title>
         <clause id="Q1" inline-header="false" obligation="normative">
         <title>Annex A.1a</title>
         </clause>
         <references id="Q2" normative="false"><title>Annex Bibliography</title></references>
       </clause>
       </annex>
       <annex id="P1" inline-header="false" obligation="normative">
       </annex>
        <bibliography><references id="R" obligation="informative" normative="true">
         <title>Normative References</title>
       </references><clause id="S" obligation="informative">
         <title>Bibliography</title>
         <references id="T" obligation="informative" normative="false">
         <title>Bibliography Subsection</title>
       </references>
       </clause>
       </bibliography>
       </iso-standard>
    INPUT
    <html xmlns:epub='http://www.idpf.org/2007/ops' lang='en'>
  <head/>
  <body lang='en'>
    <div class='title-section'>
      <p>&#160;</p>
    </div>
    <br/>
    <div class='prefatory-section'>
      <p>&#160;</p>
    </div>
    <br/>
    <div class='main-section'>
      <div class='authority'>
        <div class='boilerplate-copyright'>
          <div>
            <h1>Copyright</h1>
          </div>
        </div>
        <div class='boilerplate-license'>
          <div>
            <h1>License</h1>
          </div>
        </div>
        <div class='boilerplate-legal'>
          <div>
            <h1>Legal</h1>
          </div>
        </div>
        <div class='boilerplate-feedback'>
          <div>
            <h1>Feedback</h1>
          </div>
        </div>
      </div>
      <br/>
      <div>
        <h1 class='AbstractTitle'>Abstract</h1>
      </div>
      <br/>
      <div>
        <h1 class='ForewordTitle'>Foreword</h1>
        <p id='A'>This is a preamble</p>
      </div>
      <br/>
      <div class='Section3' id='B'>
        <h1 class='IntroTitle'>Introduction</h1>
        <div id='C'>
          <h1>Introduction Subsection</h1>
        </div>
      </div>
      <br/>
      <div class='Section3' id='B1'>
        <h1 class='IntroTitle'>Dedication</h1>
      </div>
      <br/>
      <div class='Section3' id='B2'>
        <h1 class='IntroTitle'>Note to reader</h1>
      </div>
      <br/>
      <div class='Section3' id=''>
        <h1 class='IntroTitle'>Acknowledgements</h1>
      </div>
      <p class='zzSTDTitle1'/>
      <div id='D'>
        <h1>Scope</h1>
        <p id='E'>Text</p>
      </div>
      <div>
        <h1>Normative references</h1>
      </div>
      <div id='M'>
        <h1>Clause 4</h1>
        <div id='N'>
          <h1>Introduction</h1>
        </div>
        <div id='O'>
          <h1>Clause 4.2</h1>
        </div>
        <div id='O1'>
        <span class='zzMoveToFollowing'>
  <b/>
</span>
        </div>
      </div>
      <br/>
      <div id='P' class='Section3'>
        <h1 class='Annex'>
        <b>Annex A</b>
          <br/>
          (normative)
          <br/>
          <br/>
          <b>Annex</b>
        </h1>
        <div id='Q'>
          <h2>A.1&#160; Annex A.1</h2>
          <div id='Q1'>
            <h3>A.1.1&#160; Annex A.1a</h3>
          </div>
          <div>
          <h3>A.1.2&#160; Annex Bibliography</h3>
          </div>
        </div>
      </div>
      <br/>
      <div id='P1' class='Section3'>
        <h1 class='Annex'>
        <b>Annex B</b>
<br/>
(normative)
          <br/>
          <br/>
          <b/>
        </h1>
      </div>
      <br/>
      <div>
        <h1 class='Section3'>Bibliography</h1>
        <div>
          <h2 class='Section3'>Bibliography Subsection</h2>
        </div>
      </div>
    </div>
  </body>
</html>
OUTPUT
    end

     it "processes IsoXML metadata" do
    c = IsoDoc::Iso::HtmlConvert.new({})
    arr = c.convert_init(<<~"INPUT", "test", false)
    <iso-standard xmlns="http://riboseinc.com/isoxml">
    INPUT
  expect(Hash[c.info(Nokogiri::XML(<<~"INPUT"), nil).sort]).to be_equivalent_to <<~"OUTPUT"
      <iso-standard xmlns='https://www.metanorma.org/ns/iso'>
  <bibdata type='standard'>
    <title language='en' format='text/plain' type='main'>Introduction — Main Title — Title — Title Part  — Mass fraction of
       extraneous matter, milled rice (nonglutinous), sample dividers and
       recommendations relating to storage and transport conditions</title>
    <title language='en' format='text/plain' type='title-intro'>Introduction</title>
    <title language='en' format='text/plain' type='title-main'>Main Title — Title</title>
    <title language='en' format='text/plain' type='title-part'>Title Part</title>
    <title language='en' format='text/plain' type='title-amd'>Mass fraction of extraneous matter, milled rice (nonglutinous), sample dividers and recommendations relating to storage and transport conditions</title>
<title language='fr' format='text/plain' type='main'>
  Introduction Française — Titre Principal — Part du Titre — Fraction
  massique de matière étrangère, riz usiné (non gluant), diviseurs
  d’échantillon et recommandations relatives aux conditions d’entreposage et
  de transport
</title>
    <title language='fr' format='text/plain' type='title-intro'>Introduction Française</title>
    <title language='fr' format='text/plain' type='title-main'>Titre Principal</title>
    <title language='fr' format='text/plain' type='title-part'>Part du Titre</title>
    <title language='fr' format='text/plain' type='title-amd'>Fraction massique de matière étrangère, riz usiné (non gluant), diviseurs d’échantillon et recommandations relatives aux conditions d’entreposage et de transport</title>
    <docidentifier type='iso'>ISO/PreNWIP3 17301-1:2016/Amd.1</docidentifier>
    <docidentifier type='iso-with-lang'>ISO/PreNWIP3 17301-1:2016/Amd.1(E)</docidentifier>
    <docidentifier type='iso-reference'>ISO/PreNWIP3 17301-1:2016/Amd.1:2017(E)</docidentifier>
    <docnumber>17301</docnumber>
    <date type='created'>
      <on>2016-05-01</on>
    </date>
    <contributor>
      <role type='author'/>
      <organization>
        <name>International Organization for Standardization</name>
        <abbreviation>ISO</abbreviation>
      </organization>
    </contributor>
    <contributor>
      <role type='publisher'/>
      <organization>
        <name>International Organization for Standardization</name>
        <abbreviation>ISO</abbreviation>
      </organization>
    </contributor>
    <edition>2</edition>
    <version>
      <revision-date>2000-01-01</revision-date>
      <draft>0.3.4</draft>
    </version>
    <language>en</language>
    <script>Latn</script>
    <status>
      <stage abbreviation='NWIP'>10</stage>
      <substage>20</substage>
      <iteration>3</iteration>
    </status>
    <copyright>
      <from>2017</from>
      <owner>
        <organization>
          <name>International Organization for Standardization</name>
          <abbreviation>ISO</abbreviation>
        </organization>
      </owner>
    </copyright>
    <ext>
      <doctype>amendment</doctype>
      <editorialgroup>
        <technical-committee number='1' type='A'>TC</technical-committee>
        <technical-committee number='11' type='A1'>TC1</technical-committee>
        <subcommittee number='2' type='B'>SC</subcommittee>
        <subcommittee number='21' type='B1'>SC1</subcommittee>
        <workgroup number='3' type='C'>WG</workgroup>
        <workgroup number='31' type='C1'>WG1</workgroup>
        <secretariat>SECRETARIAT</secretariat>
      </editorialgroup>
      <ics>
        <code>1</code>
      </ics>
      <ics>
        <code>2</code>
      </ics>
      <ics>
        <code>3</code>
      </ics>
      <structuredidentifier>
        <project-number part='1' amendment='1' corrigendum='2' origyr='2016-05-01'>17301</project-number>
      </structuredidentifier>
      <stagename>New work item proposal</stagename>
      <updates-document-type>international-standard</updates-document-type>
    </ext>
  </bibdata>
  <sections/>
</iso-standard>
INPUT
{:agency=>"ISO",
:authors=>[],
:authors_affiliations=>{},
:createddate=>"2016-05-01",
:docnumber=>"ISO/PreNWIP3 17301-1:2016/Amd.1",
:docnumber_lang=>"ISO/PreNWIP3 17301-1:2016/Amd.1(E)",
:docnumber_reference=>"ISO/PreNWIP3 17301-1:2016/Amd.1:2017(E)",
:docnumeric=>"17301",
:docsubtitle=>"Introduction Fran&#xe7;aise&nbsp;&mdash; Titre Principal&nbsp;&mdash; Partie&nbsp;1: Part du Titre",
:docsubtitleamd=>"Fraction massique de mati&#xe8;re &#xe9;trang&#xe8;re, riz usin&#xe9; (non gluant), diviseurs d&#x2019;&#xe9;chantillon et recommandations relatives aux conditions d&#x2019;entreposage et de transport",
:docsubtitleamdlabel=>"AMENDMENT&nbsp;1",
:docsubtitlecorrlabel=>"RECTIFICATIF TECHNIQUE&nbsp;2",
:docsubtitleintro=>"Introduction Fran&#xe7;aise",
:docsubtitlemain=>"Titre Principal",
:docsubtitlepart=>"Part du Titre",
:docsubtitlepartlabel=>"Partie&nbsp;1",
:doctitle=>"Introduction&nbsp;&mdash; Main Title&#x2009;&#x2014;&#x2009;Title&nbsp;&mdash; Part&nbsp;1: Title Part",
:doctitleamd=>"Mass fraction of extraneous matter, milled rice (nonglutinous), sample dividers and recommendations relating to storage and transport conditions",
:doctitleamdlabel=>"AMENDMENT&nbsp;1",
:doctitlecorrlabel=>"TECHNICAL CORRIGENDUM&nbsp;2",
:doctitleintro=>"Introduction",
:doctitlemain=>"Main Title&#x2009;&#x2014;&#x2009;Title",
:doctitlepart=>"Title Part",
:doctitlepartlabel=>"Part&nbsp;1",
:doctype=>"Amendment",
:docyear=>"2017",
:draft=>"0.3.4",
:draftinfo=>" (draft 0.3.4, 2000-01-01)",
:edition=>"2",
:editorialgroup=>["A 1", "B 2", "C 3"],
:ics=>"1, 2, 3",
:keywords=>[],
:obsoletes=>nil,
:obsoletes_part=>nil,
:publisher=>"International Organization for Standardization",
:revdate=>"2000-01-01",
:revdate_monthyear=>"January 2000",
:sc=>"B 2",
:secretariat=>"SECRETARIAT",
:stage=>"10",
:stage_int=>10,
:stageabbr=>"NWIP",
:statusabbr=>"PreNWIP3",
:tc=>"A 1",
:tc_docnumber=>[],
:unpublished=>true,
:wg=>"C 3"}
OUTPUT
  end

  it "processes middle title" do
         expect(xmlpp(IsoDoc::Iso::HtmlConvert.new({}).convert("test", <<~"INPUT", true))).to be_equivalent_to xmlpp(<<~"OUTPUT")
      <iso-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata>
          <title language='en' format='text/plain' type='title-intro'>Introduction</title>
    <title language='en' format='text/plain' type='title-main'>Main Title — Title</title>
    <title language='en' format='text/plain' type='title-part'>Title Part</title>
    <title language='en' format='text/plain' type='title-amd'>Mass fraction of extraneous matter, milled rice (nonglutinous), sample dividers and recommendations relating to storage and transport conditions</title>
    <ext>
          <structuredidentifier>
        <project-number part='1' amendment='1' corrigendum='2' origyr='2016-05-01'>17301</project-number>
      </structuredidentifier>
</ext>
      </bibdata>
       <sections/>
      </iso-standard>
    INPUT
    #{HTML_HDR}
      <p class='zzSTDTitle1'>Introduction &#8212; Main Title&#8201;&#8212;&#8201;Title &#8212; </p>
      <p class='zzSTDTitle2'>
        Part&#160;1:
        <br/><b>Title Part</b>
      </p>
          <p class='zzSTDTitle2'>
      AMENDMENT&#160;1: Mass fraction of extraneous matter, milled rice
      (nonglutinous), sample dividers and recommendations relating to storage
      and transport conditions
    </p>
    <p class='zzSTDTitle2'>TECHNICAL CORRIGENDUM&#160;2</p>
    </div>
  </body>
</html>
    OUTPUT
      end


end
