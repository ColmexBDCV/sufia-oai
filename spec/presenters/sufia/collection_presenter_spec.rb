require 'rails_helper'

RSpec.describe Sufia::CollectionPresenter do
  subject { described_class.new(document, ability) }

  let(:ability) { double }
  let(:collection) { build(:collection) }
  let(:document) { SolrDocument.new(collection.to_solr) }

  let(:presented_terms) do
    [:title, :total_items, :size, :resource_type, :description, :creator,
     :contributor, :keyword, :rights, :publisher, :date_created, :subject,
     :language, :identifier, :based_near, :related_url]
  end

  describe "delegations" do
    it { is_expected.to delegate_method(:resource_type).to(:solr_document) }
    it { is_expected.to delegate_method(:based_near).to(:solr_document) }
    it { is_expected.to delegate_method(:related_url).to(:solr_document) }
  end

  describe ".terms" do
    it 'returns the full list of collection terms' do
      expect(described_class.terms).to eq presented_terms
    end
  end

  describe "#terms_with_values" do
    let(:collection) do
      build(:collection, title: ['My Coll'], description: ['Really neat'])
    end

    it 'returns only terms that have values' do
      expect(subject.terms_with_values.count).to be 4
    end
  end

  describe "#[]" do
    it 'returns the size of the collection for the :size key' do
      expect(subject[:size]).to eq '0 Bytes'
    end

    it 'returns the total items in the collection for the :total_items key' do
      expect(subject[:total_items]).to be 0
    end

    it 'returns a value from the Solr document for other keys' do
      expect(subject[:title]).to eq collection.title
    end
  end

  describe '#display_feature_link?' do
    let(:collection) { build(:collection, :public) }

    before do
      allow(ability).to receive(:can?).with(:create, FeaturedCollection).and_return(true)
    end

    context 'when the user can feature collections, the collection is '\
    'public, more featured collections are allowed, and it is not already '\
    'featured' do
      it { expect(subject.display_feature_link?).to be true }
    end

    context 'when the user cannot feature collections' do
      before do
        allow(ability).to receive(:can?).with(:create, FeaturedCollection).and_return(false)
      end

      it { expect(subject.display_feature_link?).to be false }
    end

    context 'when the collection is not public' do
      let(:collection) { build(:collection, :private) }
      it { expect(subject.display_feature_link?).to be false }
    end

    context 'when there are too many featured collections' do
      before do
        allow(FeaturedCollection).to receive(:count).and_return(6)
      end

      it { expect(subject.display_feature_link?).to be false }
    end

    context 'when the collection is featured' do
      let(:collection) { create(:collection, :without_validations) }
      let!(:featured) { create(:featured_collection, collection_id: collection.id) }
      it { expect(subject.display_feature_link?).to be false }
    end
  end

  describe '#display_unfeature_link?' do
    let(:collection) { create(:collection, :public, :without_validations) }
    let!(:featured) { create(:featured_collection, collection_id: collection.id) }

    before do
      allow(ability).to receive(:can?).with(:create, FeaturedCollection).and_return(true)
    end

    context 'when the user can feature collections, the collection is '\
    'public, and it is featured' do
      it { expect(subject.display_unfeature_link?).to be true }
    end

    context 'when the user cannot feature collections' do
      before do
        allow(ability).to receive(:can?).with(:create, FeaturedCollection).and_return(false)
      end

      it { expect(subject.display_unfeature_link?).to be false }
    end

    context 'when the collection is not public' do
      let(:collection) { build(:collection, :private) }
      it { expect(subject.display_unfeature_link?).to be false }
    end

    context 'when the collection is not featured' do
      let!(:featured) { nil }
      it { expect(subject.display_unfeature_link?).to be false }
    end
  end
end
