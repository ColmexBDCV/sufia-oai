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
      let(:options) { { template: 'http://example.com/%{value}' } }
      let(:tr_content) do
        "<tr><th>Name</th>\n" \
         "<td><ul class='tabular'>" \
         "<li class=\"attribute name\">"\
         "<a href=\"http://example.com/somepath\">"\
         "somepath</a>"\
         " <span class='glyphicon glyphicon-new-window'></span></li>\n" \
         "</ul></td></tr>"
      end

      it 'links to the rendered template URL' do
        expect(subject).to be_equivalent_to(expected)
      end
    end

    context 'when no template is provided' do
      let(:tr_content) do
        "<tr><th>Name</th>\n" \
         "<td><ul class='tabular'>" \
         "<li class=\"attribute name\">"\
         "<a href=\"http://example.com/\">"\
         "http://example.com/</a>"\
         " <span class='glyphicon glyphicon-new-window'></span></li>\n" \
         "</ul></td></tr>"
      end

      it 'uses the raw value' do
        expect(subject).to be_equivalent_to(expected)
      end
    end

    context 'when the attribute value contains percent signs' do
      let(:value) { 'http://example.com/foo%C3%A9bar/' }
      let(:tr_content) do
        "<tr><th>Name</th>\n"\
         "<td><ul class='tabular'>"\
         "<li class=\"attribute name\">\n"\
         "<a href=\"http://example.com/foo%C3%A9bar/\">"\
         "http://example.com/foo%C3%A9bar/</a>"\
         " <span class='glyphicon glyphicon-new-window'></span></li>" \
         "</ul></td></tr>"
      end

      it 'renders the URL with percent signs' do
        expect(subject).to be_equivalent_to(expected)
      end
    end
  end
end
