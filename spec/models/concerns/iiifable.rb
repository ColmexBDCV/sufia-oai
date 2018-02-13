require 'rails_helper'

RSpec.shared_examples_for "iiifable" do
  let(:file_id) { 'g7337060b' }
  let(:file_version) { nil }

  before do
    allow(subject).to receive(:original_file_id).and_return file_id
    allow(subject).to receive(:original_file_version).and_return file_version
  end

  describe '#iiif_id' do
    it 'returns a tree-ified ID for the original file' do
      expect(subject.iiif_id).to eq 'g7/33/70/60/g7337060b'
    end

    context 'with a file version' do
      let(:file_version) { 'version1' }

      it 'returns an ID containing the version' do
        expect(subject.iiif_id).to eq 'g7/33/70/60/g7337060b-version1'
      end

      context 'and additional elements' do
        it 'returns an ID containing the version and the additions' do
          expect(subject.iiif_id('addl')).to eq 'g7/33/70/60/g7337060b-version1-addl'
        end
      end
    end

    context 'with additional elements' do
      it 'returns an ID containing each additional element' do
        expect(subject.iiif_id('foo', 'bar')).to eq 'g7/33/70/60/g7337060b-foo-bar'
      end
    end

    context 'with no original file ID' do
      let(:file_id) { nil }

      it 'returns nil' do
        expect(subject.iiif_id).to be_nil
      end
    end
  end
end
