require 'rails_helper'

RSpec.describe Unit, type: :model do
  describe "validation" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:key) }
  end

  describe "associations" do
    it { is_expected.to have_many(:memberships).dependent(:destroy) }
    it { is_expected.to have_many(:members) }
    it { is_expected.to accept_nested_attributes_for(:memberships) }
  end
end
