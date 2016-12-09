require 'rails_helper'

RSpec.describe Unit, type: :model do
  describe "validation" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to allow_value('foo-1').for(:key) }
    it { is_expected.not_to allow_value('foo@s1').for(:key) }

    it 'validates that :key is case-sensitively unique' do
      create(:unit, key: 'myunit')
      unit = build(:unit, :allow_duplicate, name: 'Unit2', key: 'myunit')
      expect(unit).not_to be_valid
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:memberships).dependent(:destroy) }
    it { is_expected.to have_many(:members) }
    it { is_expected.to accept_nested_attributes_for(:memberships) }
  end
end
