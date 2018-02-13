require 'rails_helper'

RSpec.describe CatalogSearchBuilder do
  subject { described_class.new(scope) }

  let(:user) { create(:user) }
  let(:config) { CatalogController.blacklight_config }
  let(:scope) do
    instance_double('The scope',
                    blacklight_config: config,
                    params: {},
                    current_ability: Ability.new(user),
                    current_user: user)
  end

  describe '.default_processor_chain' do
    it 'contains the multivalued filter processor' do
      expect(described_class.default_processor_chain).to include(:multivalued_filters)
    end
  end

  describe '#multivalued_filters' do
    let(:params) { Blacklight::Solr::Request.new(fq: filters) }
    let(:filters) do
      ["{!term f=archival_unit_sim tag=au}+//ISIL US-ou//TEXT EAD::SPEC.RARE.0137::ref11//EN",
       "{!term f=archival_unit_sim tag=au}ANOTHER_THING",
       "{!term f=foo}bar"]
    end

    it 'transforms multivalued fields into a single OR query' do
      expected = '{!tag=au}archival_unit_sim:"+//ISIL US-ou//TEXT EAD::SPEC.RARE.0137::ref11//EN" {!tag=au}archival_unit_sim:"ANOTHER_THING"'
      expect(subject.multivalued_filters(params)).to include(expected)
    end

    it 'removes the original queries' do
      expect(subject.multivalued_filters(params)).not_to include("{!term f=archival_unit_sim tag=au}+//ISIL US-ou//TEXT EAD::SPEC.RA'RE.0137::ref11//EN")
      expect(subject.multivalued_filters(params)).not_to include("{!term f=archival_unit_sim tag=au}ANOTHER_THING")
    end

    it 'leaves single value fields alone' do
      expect(subject.multivalued_filters(params)).to include("{!term f=foo}bar")
    end

    context 'with one value' do
      let(:filters) { ["{!term f=archival_unit_sim tag=au}MY_COOL_ID"] }

      it 'generates the query' do
        expect(subject.multivalued_filters(params)).to include('{!tag=au}archival_unit_sim:"MY_COOL_ID"')
      end
    end

    context 'with no tag' do
      let(:filters) { ["{!term f=archival_unit_sim}MY_COOL_ID"] }

      it 'generates the query without local params' do
        expect(subject.multivalued_filters(params)).to include('archival_unit_sim:"MY_COOL_ID"')
      end
    end
  end
end
