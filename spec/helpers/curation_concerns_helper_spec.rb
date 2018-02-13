require 'rails_helper'

RSpec.describe CurationConcernsHelper do
  describe 'modules' do
    it { is_expected.to include_module(::BlacklightHelper) }
    it { is_expected.to include_module(CurationConcerns::MainAppHelpers) }
  end

  describe 'format_characterization_values' do
    let(:values) { ['12000'] }

    context 'for file size' do
      it 'returns a human readable file size' do
        expect(helper.format_characterization_values(:file_size, values)).to eq ['11.7 KB']
      end
    end

    context 'for width and height' do
      it 'appends "px" to the value' do
        expect(helper.format_characterization_values(:width, values)).to eq ['12000 px']
        expect(helper.format_characterization_values(:height, values)).to eq ['12000 px']
      end
    end

    context 'for other terms' do
      it 'does not alter the value' do
        expect(helper.format_characterization_values(:foo, values)).to eq ['12000']
      end
    end
  end
end
