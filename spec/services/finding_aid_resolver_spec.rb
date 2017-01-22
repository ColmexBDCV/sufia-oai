require 'rails_helper'

RSpec.describe FindingAidResolver do
  subject { described_class.new(ead_id) }
  let(:ead_id) { 'SPEC.RARE.0137:ref11' }

  describe '#path' do
    it 'builds the correct path to the EAD XML' do
      expect(subject.path).to eq 'RARE/SPEC.RARE.0137.xml#ref11'
    end
  end

  describe '#url' do
    before do
      allow(Rails.configuration).to receive_message_chain('x.finding_aid_base').and_return('http://example.com/')
    end

    it 'builds the full URL to the EAD XML' do
      expect(subject.url).to eq 'http://example.com/RARE/SPEC.RARE.0137.xml#ref11'
    end
  end

  describe '#prefix' do
    context 'with a Byrd identifier' do
      let(:ead_id) { 'SPEC.PA.56.1234:ref45' }

      it 'returns the Byrd prefix' do
        expect(subject.prefix).to eq 'ByrdPolar'
      end
    end

    context 'with a Cartoons identifier' do
      let(:ead_id) { 'SPEC.CGA.TYU.1234:ref12' }

      it 'returns the Cartoon prefix' do
        expect(subject.prefix).to eq 'Cartoons'
      end
    end

    context 'with an invalid identifier' do
      let(:ead_id) { 'FOO.BAR:ref12' }

      it 'returns nil' do
        expect(subject.prefix).to be_nil
      end
    end
  end
end
