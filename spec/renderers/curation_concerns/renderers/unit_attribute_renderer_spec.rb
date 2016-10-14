require 'rails_helper'

RSpec.describe CurationConcerns::Renderers::UnitAttributeRenderer do
  subject { described_class.new(field, [key]) }
  let(:unit) { create(:unit, name: 'The Unit', key: 'thekey') }
  let(:field) { :unit }
  let(:key) { 'nounit' }

  describe 'modules' do
    it { is_expected.to include_module(::UnitsHelper) }
  end

  describe "#attribute_to_html" do
    let(:rendered) { Nokogiri::HTML(subject.render) }
    let(:expected) { Nokogiri::HTML(tr_content) }

    context 'the unit exists' do
      let(:key) { unit.key }
      let(:tr_content) {
        "<tr><th>Unit</th>\n" \
         "<td><ul class='tabular'>" \
         "<li class=\"attribute unit\">"\
         "<a href=\"/catalog?q=thekey&amp;search_field=unit_tesim\">"\
         "The Unit</a></li>\n" \
         "</ul></td></tr>"
      }

      it 'should use the unit name' do
        expect(rendered).to be_equivalent_to(expected)
      end
    end

    context 'the unit does not exist' do
      let(:tr_content) {
        "<tr><th>Unit</th>\n" \
         "<td><ul class='tabular'>" \
         "<li class=\"attribute unit\">"\
         "<a href=\"/catalog?q=nounit&amp;search_field=unit_tesim\">"\
         "nounit</a></li>\n" \
         "</ul></td></tr>"
      }

      it 'should use the raw value' do
        expect(rendered).to be_equivalent_to(expected)
      end
    end
  end
end
