require 'rails_helper'

RSpec.shared_examples_for "materials_edit_form" do
  it { is_expected.to delegate_method(:materials).to(:model) }
  it { is_expected.to delegate_method(:materials_attributes=).to(:model).with_arguments({}) }

  describe '#terms' do
    it 'includes terms for materials' do
      expect(subject.terms).to include :materials_attributes
    end
  end

  describe '.build_permitted_params' do
    it 'includes attributes for materials' do
      expect(described_class.build_permitted_params).to include :materials_attributes
    end
  end
end
