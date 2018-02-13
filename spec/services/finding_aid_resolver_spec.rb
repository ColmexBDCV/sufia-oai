require 'rails_helper'

RSpec.describe FindingAidResolver do
  subject { described_class.new(ead_id) }
  let(:ead_id) { '+//ISIL US-ou//TEXT EAD::SPEC.RARE.0137::ref11//EN' }

  describe '#path' do
    it 'builds the correct path to the EAD XML and ID fragment' do
      expect(subject.path).to eq 'RARE/SPEC.RARE.0137.xml#ref11'
    end

    context 'with no persistent ID' do
      let(:ead_id) { '+//ISIL US-ou//TEXT EAD::SPEC.RARE.0137//EN' }

      it 'builds the correct path to the EAD XML' do
        expect(subject.path).to eq 'RARE/SPEC.RARE.0137.xml'
      end
    end
  end

  describe '#initialize' do
    context 'with an invalid identifier' do
      let(:ead_id) { 'invalid' }

      it 'throws an exception' do
        expect { subject }.to raise_error ArgumentError
      end
    end

    context 'with an identifier containing no language' do
      let(:ead_id) { '+//ISIL US-ou//TEXT EAD::SPEC.RARE.0137::ref11' }

      it 'extracts the collection and pid' do
        expect(subject.collection).to eq 'SPEC.RARE.0137'
        expect(subject.identifier).to eq 'ref11'
      end
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
      let(:ead_id) { '+//ISIL US-ou//TEXT EAD::SPEC.PA.56.1234::ref45//EN' }

      it 'returns the Byrd prefix' do
        expect(subject.prefix).to eq 'ByrdPolar'
      end
    end

    context 'with a Cartoons identifier' do
      let(:ead_id) { '+//ISIL US-ou//TEXT EAD::SPEC.CGA.TYU.1234::ref12//EN' }

      it 'returns the Cartoon prefix' do
        expect(subject.prefix).to eq 'Cartoons'
      end
    end

    context 'with an invalid identifier' do
      let(:ead_id) { '+//ISIL US-ou//TEXT EAD::FOO.BAR::ref12//EN' }

      it 'returns nil' do
        expect(subject.prefix).to be_nil
      end
    end
  end

  describe '#short_id' do
    it 'returns a shortened version of the ADU identifier' do
      expect(subject.short_id).to eq 'SPEC.RARE.0137::ref11'
    end
  end
end
