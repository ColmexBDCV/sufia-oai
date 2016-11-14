require 'rails_helper'

RSpec.shared_examples_for "measurements_edit_form" do
  it { is_expected.to delegate_method(:measurements).to(:model) }
  it { is_expected.to delegate_method(:measurements_attributes=).to(:model).with_arguments({}) }

  describe '#terms' do
    it 'includes terms for measurements' do
      expect(subject.terms).to include :measurements_attributes
    end
  end

  describe '.build_permitted_params' do
    it 'includes attributes for measurements' do
      expect(described_class.build_permitted_params).to include :measurements_attributes
    end
  end
end
