require 'rails_helper'

RSpec.describe CurationConcerns::Renderers::LinkedResourceAttributeRenderer do
  let(:options) { {} }
  let(:value) { 'http://example.com/' }
  let(:renderer) { described_class.new(:name, [value], options) }

  describe "#attribute_to_html" do
    subject { Nokogiri::HTML(renderer.render) }
    let(:expected) { Nokogiri::HTML(tr_content) }

    context 'when a template is provided' do
      let(:value) { 'somepath' }
      let(:options) { {template: 'http://example.com/%{value}'} }
      let(:tr_content) {
        "<tr><th>Name</th>\n" \
         "<td><ul class='tabular'>" \
         "<li class=\"attribute name\">"\
         "<a href=\"http://example.com/somepath\">"\
         "<span class='glyphicon glyphicon-new-window'></span>&nbsp;"\
         "somepath</a></li>\n" \
         "</ul></td></tr>"
      }

      it 'should link to the rendered template URL' do
        expect(subject).to be_equivalent_to(expected)
      end
    end

    context 'when no template is provided' do
      let(:tr_content) {
        "<tr><th>Name</th>\n" \
         "<td><ul class='tabular'>" \
         "<li class=\"attribute name\">"\
         "<a href=\"http://example.com/\">"\
         "<span class='glyphicon glyphicon-new-window'></span>&nbsp;"\
         "http://example.com/</a></li>\n" \
         "</ul></td></tr>"
      }

      it 'should use the raw value' do
        expect(subject).to be_equivalent_to(expected)
      end
    end
  end
end
