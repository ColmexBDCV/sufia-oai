require 'rails_helper'

RSpec.shared_examples_for "physical_media_metadata" do
  describe "assotiations" do
    it { is_expected.to respond_to(:materials) }
    it { is_expected.to respond_to(:measurements) }

    it { is_expected.to accept_nested_attributes_for(:materials) }
    it { is_expected.to accept_nested_attributes_for(:measurements) }
  end
end
