require 'rails_helper'

RSpec.describe DashboardHelper do
  describe 'modules' do
    it { is_expected.to include_module(Sufia::DashboardHelperBehavior) }
  end

  describe "#on_my_works?" do
    it "returns false when the controller isn't my works or my units" do
      allow(helper).to receive(:params).and_return(controller: "my/collections")
      expect(helper).not_to be_on_my_works
    end

    it "returns true when the controller is my works" do
      allow(helper).to receive(:params).and_return(controller: "my/works")
      expect(helper).to be_on_my_works
    end

    it "returns true when the controller is my units" do
      allow(helper).to receive(:params).and_return(controller: "my/units")
      expect(helper).to be_on_my_works
    end
  end
end
