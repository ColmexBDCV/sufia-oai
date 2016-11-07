require 'rails_helper'

# Updated ENV vars were added to config/environments/test.rb so this stuff
# can work successfully.

RSpec.describe BatchImportService do
  let!(:user)    { create(:admin_user) }
  let!(:unit)    { FactoryGirl.create(:unit) }
  let!(:import1) { FactoryGirl.create(:simple_import,   unit: unit) }
  let!(:import2) { FactoryGirl.create(:complex_import,  unit: unit) }
  let!(:import3) { FactoryGirl.create(:complex_orphans, unit: unit) }

  it "wil validate CSV by finding orphaned children" do
    expect(import1.validate_complex_objects).to eq(0)
    expect(import2.validate_complex_objects).to eq(0)
    expect(import3.validate_complex_objects).to eq(1)
  end

  it "will successfully schedule a an import" do
    import1.ready!
    described_class.new(import1, user).schedule
    expect(import1.in_progress?).to eq(true)
  end

  it "Simple Import: will ingest all row of a CSV" do
    batch_import = described_class.new(import1, user)

    call_count = 0
    allow(batch_import).to receive(:process_import_item) {call_count += 1}
    batch_import.process

    expect(call_count).to eq(3)
  end

  it "Complex Import: will ingest all rows of a CSV" do
    batch_import = described_class.new(import2, user)

    call_count = 0
    allow(batch_import).to receive(:process_import_item) {call_count += 1}
    batch_import.process

    expect(call_count).to eq(3)
  end

  it "Simple Import: Creates on GenericWork with 1 Image in Fileset" do
    batch_import = described_class.new(import1, user)

    row = ["image", "Dreese", "Dreese Hall photo", "building", "osu", nil, "university", "archive", "50 x 25 cm", "paper", nil, "179.jpg", "Bartos, Chris", nil]
    files = [{ filename: "181.jpg", title: "Hayes" }]

    allow(CreateDerivativesJob).to receive(:perform_now) {}
    gw = batch_import.instance_eval { ingest(row, files) }

    expect(gw.file_sets.count).to eq(1)
  end

  it "Simple Import: Creates on GenericWork with 1 Image in Fileset and Collection_name is set" do
    batch_import = described_class.new(import1, user)

    row = ["image", "Dreese", "Dreese Hall photo", "building", "osu", nil, "university", "archive", "50 x 25 cm", "paper", nil, "179.jpg", "Bartos, Chris", "Collection Name"]
    files = [{ filename: "181.jpg", title: "Hayes" }]

    allow(CreateDerivativesJob).to receive(:perform_now) {}
    gw = batch_import.instance_eval { ingest(row, files) }

    expect(gw.file_sets.count).to eq(1)
    expect(gw.collection_name.first).to eq("Collection Name")
  end

  it "Complex Import: Creates on GenericWork with 3 Images in Fileset" do
    batch_import = described_class.new(import2, user)

    row = ["images", "Halls", "Collection of Halls", "building", "osu", nil, "university", "archive", "50 x 25 cm", "paper", nil, nil, "Bartos, Chris", "1", nil]
    files = [{ filename: "179.jpg", title: "Dreese" }, { filename: "181.jpg", title: "Hayes" }, { filename: "209.jpg", title: "Orton" }]

    allow(CreateDerivativesJob).to receive(:perform_now) {}
    gw = batch_import.instance_eval { ingest(row, files) }

    expect(gw.file_sets.count).to eq(3)
  end

  it "Complex Import: Get pid, cid, and title from row" do
    batch_import = described_class.new(import2, user)

    row = ["images", "Halls", "Collection of Halls", "building", "osu", nil, "university", "archive", "50 x 25 cm", "paper", nil, nil, "Bartos, Chris", "1", nil]

    cid = batch_import.instance_eval { get_cid_from(row) }
    pid = batch_import.instance_eval { get_pid_from(row) }
    title = batch_import.instance_eval { get_title_from(row) }

    expect(cid).to eq(nil)
    expect(pid).to eq("1")
    expect(title).to eq("Halls")
  end

  it "Simple Import: Get pid, cid, and title from row" do
    batch_import = described_class.new(import1, user)

    row = ["image", "Dreese", "Dreese Hall photo", "building", "osu", nil, "university", "archive", "50 x 25 cm", "paper", nil, "179.jpg", "Bartos, Chris"]

    cid = batch_import.instance_eval { get_cid_from(row) }
    pid = batch_import.instance_eval { get_pid_from(row) }
    title = batch_import.instance_eval { get_title_from(row) }

    expect(cid).to eq(nil)
    expect(pid).to eq(nil)
    expect(title).to eq("Dreese")
  end
end
