require 'rails_helper'

# Updated ENV vars were added to config/environments/test.rb so this stuff
# can work successfully.

RSpec.describe BatchImportService do
  let!(:user)   { create(:admin_user) }
  let!(:unit)   { FactoryGirl.create(:unit) }
  let!(:import1) { FactoryGirl.create(:import, unit: unit) }

  it "will successfully schedule a an import" do
    import1.ready!
    described_class.new(import1, user).schedule
    expect(import1.in_progress?).to eq(true)
  end

  it "will ingest a row of a CSV" do
  end
end
