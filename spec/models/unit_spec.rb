require 'rails_helper'

RSpec.describe Unit, type: :model do
  describe "validation" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:key) }
  end
end
