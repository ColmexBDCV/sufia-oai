require 'rails_helper'
require 'models/concerns/iiifable'
require 'models/concerns/metadata_index_terms'
require 'models/concerns/characterization_index_terms'

RSpec.describe SolrDocument do
  subject { described_class.new(work.to_solr) }
  let(:properties) { {} }
  let(:work) { build_stubbed(:generic_work, properties) }

  it_behaves_like 'iiifable'
  it_behaves_like 'metadata_index_terms'
  it_behaves_like 'characterization_index_terms'

  describe 'modules' do
    it { is_expected.to include_module(Blacklight::Solr::Document) }
    it { is_expected.to include_module(Blacklight::Gallery::OpenseadragonSolrDocument) }
    it { is_expected.to include_module(CurationConcerns::SolrDocumentBehavior) }
    it { is_expected.to include_module(Sufia::SolrDocumentBehavior) }
    it { is_expected.to include_module(BlacklightOaiProvider::SolrDocumentBehavior) }
  end

  describe '.image_mime_types' do
    it 'includes application/octet-stream' do
      expect(described_class.image_mime_types).to include('application/octet-stream')
    end
  end

  describe '#timestamp' do
    subject { described_class.new(system_modified_dtsi: date_modified) }
    let(:date_modified) { '2016-09-28T17:59:28Z' }

    it 'should return the UTC last modified time' do
      expect(subject.timestamp.iso8601).to eq date_modified
      expect(subject.timestamp).to be_a Time
    end
  end

  describe '#[]' do
    it 'should pass certain keys through without Solrizing' do
      expect(subject).to receive(:oai_identifier)
      subject['oai_identifier']
    end
  end

  describe '#oai_identifier' do
    subject { described_class.new(work.to_solr).oai_identifier }

    context 'without identifiers or handle' do
      it { is_expected.to eq [] }
    end

    context 'with identifiers' do
      let(:properties) { { identifier: %w(ident bar) } }
      it { is_expected.to eq %w(ident bar) }

      context 'and a handle' do
        let(:properties) { { identifier: %w(ident bar), handle: %w(1234/myhandle) } }
        it { is_expected.to eq %w(ident bar http://hdl.handle.net/1234/myhandle) }
      end
    end

    context 'with a handle' do
      let(:properties) { { handle: %w(1234/myhandle) } }
      it { is_expected.to eq ['http://hdl.handle.net/1234/myhandle'] }
    end
  end
end
