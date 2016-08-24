require 'rails_helper'

RSpec.describe Membership, type: :model do
  describe "validation" do
    it { is_expected.to validate_presence_of(:unit) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:level) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:unit) }
  end
end
