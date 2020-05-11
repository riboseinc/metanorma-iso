require "spec_helper"

RSpec.describe Asciidoctor::ISO do
  it "processes the Asciidoctor::ISO inline macros" do
    expect(xmlpp(Asciidoctor.convert(<<~"INPUT", backend: :iso, header_footer: true))).to be_equivalent_to xmlpp(<<~"OUTPUT")
      #{ASCIIDOC_BLANK_HDR}
      alt:[term1]
      deprecated:[term1]
      domain:[term1]
    INPUT
    #{BLANK_HDR}
       <sections>
         <admitted>term1</admitted>
       <deprecates>term1</deprecates>
       <domain>term1</domain>
       </sections>
       </iso-standard>
    OUTPUT
  end

  describe 'term inline macros' do
    subject(:convert) do
      xmlpp(
        strip_guid(
          Asciidoctor.convert(
            input, backend: :iso, header_footer: true)))
    end
    let(:input) do
      <<~XML
        #{ASCIIDOC_BLANK_HDR}
        == Terms and Definitions

        === name2

        == Main

        term:[name,name2]
      XML
    end
    let(:output) do
      <<~XML
        #{BLANK_HDR}
        <sections>
          <terms id='_' obligation='normative'>
            <title>Terms and definitions</title>
            <p id='_'>For the purposes of this document, the following terms and definitions apply.</p>
            <p id='_'>
              ISO and IEC maintain terminological databases for use in standardization
              at the following addresses:
            </p>
            <ul id='_'>
              <li>
                <p id='_'>
                  ISO Online browsing platform: available at
                  <link target='http://www.iso.org/obp'/>
                </p>
              </li>
              <li>
                <p id='_'>
                  IEC Electropedia: available at
                  <link target='http://www.electropedia.org'/>
                </p>
              </li>
            </ul>
            <term id='term-name2'>
              <preferred>name2</preferred>
            </term>
          </terms>
          <clause id='_' inline-header='false' obligation='normative'>
            <title>Main</title>
            <p id='_'>
              <em>name</em>
              (
              <xref target='term-name2'/>
              )
            </p>
          </clause>
        </sections>
        </iso-standard>
      XML
    end

    it 'converts macro into the correct xml' do
      expect(convert).to(be_equivalent_to(xmlpp(output)))
    end

    context 'default params' do
      let(:input) do
        <<~XML
          #{ASCIIDOC_BLANK_HDR}

          == Terms and Definitions

          === name

          == Main

          term:[name]
        XML
      end
      let(:output) do
        <<~XML
          #{BLANK_HDR}
          <sections>
            <terms id='_' obligation='normative'>
              <title>Terms and definitions</title>
              <p id='_'>For the purposes of this document, the following terms and definitions apply.</p>
              <p id='_'>
                ISO and IEC maintain terminological databases for use in standardization
                at the following addresses:
              </p>
              <ul id='_'>
                <li>
                  <p id='_'>
                    ISO Online browsing platform: available at
                    <link target='http://www.iso.org/obp' />
                  </p>
                </li>
                <li>
                  <p id='_'>
                    IEC Electropedia: available at
                    <link target='http://www.electropedia.org' />
                  </p>
                </li>
              </ul>
              <term id='term-name'>
                <preferred>name</preferred>
              </term>
            </terms>
            <clause id='_' inline-header='false' obligation='normative'>
              <title>Main</title>
              <p id='_'>
                <em>name</em>
                (
                <xref target='term-name' />
                )
              </p>
            </clause>
          </sections>
          </iso-standard>
        XML
      end

      it 'uses `name` as termref name' do
        expect(convert).to(be_equivalent_to(xmlpp(output)))
      end
    end

    context 'multiply exising ids in document' do
      let(:input) do
        <<~XML
          #{ASCIIDOC_BLANK_HDR}

          == Terms and Definitions

          === name
          === name2

          [[term-name]]
          == Main

          paragraph

          [[term-name2]]
          == Second

          term:[name]
          term:[name2]
        XML
      end
      let(:output) do
        <<~XML
          #{BLANK_HDR}
          <sections>
            <terms id='_' obligation='normative'>
              <title>Terms and definitions</title>
              <p id='_'>For the purposes of this document, the following terms and definitions apply.</p>
              <p id='_'>
                ISO and IEC maintain terminological databases for use in standardization
                at the following addresses:
              </p>
              <ul id='_'>
                <li>
                  <p id='_'>
                    ISO Online browsing platform: available at
                    <link target='http://www.iso.org/obp' />
                  </p>
                </li>
                <li>
                  <p id='_'>
                    IEC Electropedia: available at
                    <link target='http://www.electropedia.org' />
                  </p>
                </li>
              </ul>
              <term id='term-name-1'>
                <preferred>name</preferred>
              </term>
              <term id='term-name2-1'>
                <preferred>name2</preferred>
              </term>
            </terms>
            <clause id='term-name' inline-header='false' obligation='normative'>
              <title>Main</title>
              <p id='_'>paragraph</p>
            </clause>
            <clause id='term-name2' inline-header='false' obligation='normative'>
              <title>Second</title>
              <p id='_'>
                <em>name</em>
                (
                <xref target='term-name-1' />
                )
                <em>name2</em>
                  (
                <xref target='term-name2-1' />
                )
              </p>
            </clause>
          </sections>
          </iso-standard>
        XML
      end

      it 'generates unique ids which dont match existing ids' do
        expect(convert).to(be_equivalent_to(xmlpp(output)))
      end
    end

    context 'when missing actual ref' do
      let(:input) do
        <<~XML
          #{ASCIIDOC_BLANK_HDR}

          == Terms and Definitions

          === name

          paragraph

          term:[name]
          term:[missing]
        XML
      end
      let(:output) do
        <<~XML
          #{BLANK_HDR}
            <sections>
              <terms id='_' obligation='normative'>
                <title>Terms and definitions</title>
                <p id='_'>For the purposes of this document, the following terms and definitions apply.</p>
                <p id='_'>
                  ISO and IEC maintain terminological databases for use in standardization
                  at the following addresses:
                </p>
                <ul id='_'>
                  <li>
                    <p id='_'>
                      ISO Online browsing platform: available at
                      <link target='http://www.iso.org/obp'/>
                    </p>
                  </li>
                  <li>
                    <p id='_'>
                      IEC Electropedia: available at
                      <link target='http://www.electropedia.org'/>
                    </p>
                  </li>
                </ul>
                <term id='term-name'>
                  <preferred>name</preferred>
                  <definition>
                    <p id='_'>paragraph</p>
                    <p id='_'>
                      <em>name</em>
                       (
                      <xref target='term-name'/>
                      )
                      missing
                    </p>
                  </definition>
                </term>
              </terms>
            </sections>
          </iso-standard>
        XML
      end

      it 'generates unique ids which dont match existing ids' do
        expect(convert).to(be_equivalent_to(xmlpp(output)))
      end
    end
  end
end
