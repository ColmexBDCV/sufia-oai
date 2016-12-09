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

  describe "#current_dashboard_tab" do
    it "returns :works when the controller is my works" do
      allow(helper).to receive(:params).and_return(controller: "my/works")
      expect(helper.current_dashboard_tab).to eq :works
    end

    it "returns :units when the controller is my units" do
      allow(helper).to receive(:params).and_return(controller: "my/units")
      expect(helper.current_dashboard_tab).to eq :units
    end

    it "returns nil when the controller is not on the dashboard" do
      allow(helper).to receive(:params).and_return(controller: "units")
      expect(helper.current_dashboard_tab).to be nil
    end
  end
end
