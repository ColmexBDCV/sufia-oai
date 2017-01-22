require 'rails_helper'

RSpec.describe CurationConcerns::Renderers::EadAttributeRenderer do
  let(:value) { 'SPEC.RARE.0137:ref11' }
  let(:renderer) { described_class.new(:name, [value]) }

  before do
    allow(Rails.configuration).to receive_message_chain('x.finding_aid_base').and_return('http://example.com/')
  end

  describe "#attribute_to_html" do
    subject { Nokogiri::HTML(renderer.render) }
    let(:expected) { Nokogiri::HTML(tr_content) }

    context 'with a valid archival identifier' do
      let(:tr_content) do
        "<tr><th>Name</th>\n" \
         "<td><ul class='tabular'>" \
         "<li class=\"attribute name\">"\
         "<a href=\"http://example.com/RARE/SPEC.RARE.0137.xml#ref11\">"\
         "<span class='glyphicon glyphicon-new-window'></span>&nbsp;"\
         "SPEC.RARE.0137:ref11</a></li>\n" \
         "</ul></td></tr>"
      end

      it 'links to the finding aid' do
        expect(subject).to be_equivalent_to(expected)
      end
    end

    context 'with an invalid archival identifier' do
      let(:value) { 'invalid' }
      let(:tr_content) do
        "<tr><th>Name</th>\n" \
         "<td><ul class='tabular'>" \
         "<li class=\"attribute name\">"\
         "invalid</li>\n" \
         "</ul></td></tr>"
      end

      it 'renders the raw value' do
        expect(subject).to be_equivalent_to(expected)
      end
    end
  end
end
