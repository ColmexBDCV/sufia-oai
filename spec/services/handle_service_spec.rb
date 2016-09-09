require 'rails_helper'

require 'handle'

RSpec.describe HandleService do
  # Create Generic File
  let(:unit) { create(:unit) }

  let(:generic_work1) do
    gw = GenericWork.new(title: ["Test Generic Work"], visibility: "restricted", unit: unit.key)
    gw.save(validate: false)
    gw
  end

  let(:generic_work2) do
    gw = GenericWork.new(title: ["Test Generic Work"], visibility: "open", unit: unit.key)
    gw.save(validate: false)
    gw
  end

  let(:generic_work3) do
    gw = GenericWork.new(title: ["Test Generic Work"], visibility: "open", handle: ["1234/fake_handle_test"], unit: unit.key)
    gw.save(validate: false)
    gw
  end

  let(:handle_conn) do
    Handle::Connection.new(
      Rails.configuration.x.handle["admin_handle"],
      Rails.configuration.x.handle["index"],
      Rails.configuration.x.handle['admin_priv_key'],
      Rails.configuration.x.handle["admin_passphrase"]
    )
  end

  it "will not run the minting process with visibility = restricted" do
    # Run the HandleService
    handle_service = described_class.new(generic_work1)

    call_count = 0
    allow(handle_service).to receive(:create_handle!) { call_count += 1 }
    handle_service.mint

    # Generic File shouldn't have a handle minted.
    expect(call_count).to eq(0)
  end

  it "will not run the minting process with handle != []" do
    # Run the HandleService
    handle_service = described_class.new(generic_work3)

    call_count = 0
    allow(handle_service).to receive(:create_handle!) { call_count += 1 }
    handle_service.mint

    # Generic File shouldn't have a handle minted.
    expect(call_count).to eq(0)
  end

  it "will run the minting process with visibility = open" do
    # Run the HandleService
    handle_service = described_class.new(generic_work2)

    call_count = 0
    allow(handle_service).to receive(:create_handle!) { call_count += 1 }
    handle_service.mint

    # Generic File shouldn't have a handle minted.
    expect(call_count).to eq(1)
  end

  it "will actually create a handle successfully and update the GenericWork" do
    # Run the handle service
    described_class.new(generic_work2).mint

    # Generic File should have a handle minted.
    expect(generic_work2.handle).not_to eq([])

    # Delete handle
    handle_conn.delete_handle(generic_work2.handle[0])
  end
end
