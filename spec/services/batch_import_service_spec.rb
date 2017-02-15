require 'rails_helper'

RSpec.describe BatchImportService do
  include ActiveJob::TestHelper

  let!(:user)    { create(:admin_user) }
  let!(:unit)    { create(:unit) }
  let!(:import1) { create(:simple_import, :with_field_mappings, unit: unit) }
  let!(:import2) { create(:complex_import, :with_field_mappings, unit: unit) }
  let!(:import3) { create(:complex_orphans, :with_field_mappings, unit: unit) }
  let!(:import4) { create(:simple_with_blank_rows, :with_field_mappings, unit: unit) }

  after do
    FileUtils.rm_rf Rails.configuration.x.import.storage_path if Rails.env.test?
  end

  it "will validate CSV by finding orphaned children" do
    expect(import1.validate_complex_objects).to eq(0)
    expect(import2.validate_complex_objects).to eq(0)
    expect(import3.validate_complex_objects).to eq(1)
  end

  it "will successfully schedule a an import" do
    import1.ready!

    assert_enqueued_with(job: ImportJob) do
      described_class.new(import1, user).schedule
    end
    expect(import1.in_progress?).to eq(true)
  end

  it "Simple Import: will ingest all row of a CSV" do
    batch_import = described_class.new(import1, user)

    assert_enqueued_with(job: ProcessImportItem) do
      batch_import.process
    end
    assert_enqueued_jobs(3)
  end

  it "Simple Import: will ingest all non-blanks rows of a CSV" do
    batch_import = described_class.new(import4, user)

    assert_enqueued_with(job: ProcessImportItem) do
      batch_import.process
    end
    assert_enqueued_jobs(3)
  end

  it "Simple Import: Creates on GenericWork with 1 FileSet" do
    batch_import = described_class.new(import1, user)

    row = ["image", "Dreese", "Dreese Hall photo", "building", "osu", nil, "restricted", "university", "archive", "50 x 25 cm", "paper", nil, "179.jpg", "Bartos, Chris", nil]
    current_row = 1
    files = [{ filename: "181.jpg", title: "Hayes" }]

    work = batch_import.import_item(row, current_row, files)
    expect(work.file_sets.count).to eq(1)
  end

  it "Simple Import: Creates on GenericWork with 1 FileSet with visibility of restricted" do
    batch_import = described_class.new(import1, user)

    row = ["image", "Dreese", "Dreese Hall photo", "building", "osu", nil, "restricted", "university", "archive", "50 x 25 cm", "paper", nil, "179.jpg", "Bartos, Chris", nil]
    current_row = 1
    files = [{ filename: "181.jpg", title: "Hayes" }]

    work = batch_import.import_item(row, current_row, files)

    expect(work.visibility).to eq("restricted")
    expect(work.file_sets.first.visibility).to eq("restricted")
  end

  it "Simple Import: Creates on GenericWork with 1 FileSet with visibility of restricted when row is ''" do
    batch_import = described_class.new(import1, user)

    row = ["image", "Dreese", "Dreese Hall photo", "building", "osu", nil, "", "university", "archive", "50 x 25 cm", "paper", nil, "179.jpg", "Bartos, Chris", nil]
    current_row = 1
    files = [{ filename: "181.jpg", title: "Hayes" }]

    work = batch_import.import_item(row, current_row, files)

    expect(work.visibility).to eq("restricted")
    expect(work.file_sets.first.visibility).to eq("restricted")
  end

  it "Simple Import: Creates on GenericWork with 1 FileSet with visibility of restricted when row is nil" do
    batch_import = described_class.new(import1, user)

    row = ["image", "Dreese", "Dreese Hall photo", "building", "osu", nil, nil, "university", "archive", "50 x 25 cm", "paper", nil, "179.jpg", "Bartos, Chris", nil]
    current_row = 1
    files = [{ filename: "181.jpg", title: "Hayes" }]

    work = batch_import.import_item(row, current_row, files)

    expect(work.visibility).to eq("restricted")
    expect(work.file_sets.first.visibility).to eq("restricted")
  end

  it "Simple Import: Creates on GenericWork with 1 FileSet with visibility of open" do
    batch_import = described_class.new(import1, user)

    row = ["image", "Dreese", "Dreese Hall photo", "building", "osu", nil, "open", "university", "archive", "50 x 25 cm", "paper", nil, "179.jpg", "Bartos, Chris", nil]
    current_row = 1
    files = [{ filename: "181.jpg", title: "Hayes" }]

    work = batch_import.import_item(row, current_row, files)

    expect(work.visibility).to eq("open")
    expect(work.file_sets.first.visibility).to eq("open")
  end

  it "Simple Import: Creates on GenericWork with 1 FileSet and Collection_name is set" do
    batch_import = described_class.new(import1, user)

    row = ["image", "Dreese", "Dreese Hall photo", "building", "osu", nil, "restricted", "university", "archive", "50 x 25 cm", "paper", nil, "179.jpg", "Bartos, Chris", "Collection Name"]
    current_row = 1
    files = [{ filename: "181.jpg", title: "Hayes" }]

    work = batch_import.import_item(row, current_row, files)
    expect(work.file_sets.count).to eq(1)
    expect(work.collection_name.first).to eq("Collection Name")
  end

  it "Simple Import: Get pid, cid, and title from row" do
    batch_import = described_class.new(import1, user)

    row = ["image", "Dreese", "Dreese Hall photo", "building", "osu", nil, "restricted", "university", "archive", "50 x 25 cm", "paper", nil, "179.jpg", "Bartos, Chris"]

    cid = batch_import.instance_eval { get_cid_from(row) }
    pid = batch_import.instance_eval { get_pid_from(row) }
    title = batch_import.instance_eval { get_title_from(row) }

    expect(cid).to eq(nil)
    expect(pid).to eq(nil)
    expect(title).to eq("Dreese")
  end

  it "Simple Import: Get visibility from row" do
    batch_import = described_class.new(import1, user)

    row = ["image", "Dreese", "Dreese Hall photo", "building", "osu", nil, "restricted", "university", "archive", "50 x 25 cm", "paper", nil, "179.jpg", "Bartos, Chris"]

    visibility = batch_import.instance_eval { get_visibility_from(row) }

    expect(visibility).to eq("restricted")
  end

  it "Complex Import: will ingest all rows of a CSV" do
    batch_import = described_class.new(import2, user)

    assert_enqueued_with(job: ProcessImportItem) do
      batch_import.process
    end
    assert_enqueued_jobs(3)
  end

  it "Complex Import: Creates on GenericWork with 3 FileSets" do
    batch_import = described_class.new(import2, user)
    row = ["images", "Halls", "Collection of Halls", "building", "osu", nil, "restricted", "university", "archive", "50 x 25 cm", "paper", nil, nil, "Bartos, Chris", "1"]
    current_row = 1
    files = [{ filename: "179.jpg", title: "Dreese" }, { filename: "181.jpg", title: "Hayes" }, { filename: "209.jpg", title: "Orton" }]

    work = batch_import.import_item(row, current_row, files)
    expect(work.file_sets.count).to eq(3)
  end

  it "Complex Import: Creates on GenericWork with 3 FileSets make visibility restricted" do
    batch_import = described_class.new(import2, user)
    row = ["images", "Halls", "Collection of Halls", "building", "osu", nil, "restricted", "university", "archive", "50 x 25 cm", "paper", nil, nil, "Bartos, Chris", "1"]
    current_row = 1
    files = [{ filename: "179.jpg", title: "Dreese" }, { filename: "181.jpg", title: "Hayes" }, { filename: "209.jpg", title: "Orton" }]

    work = batch_import.import_item(row, current_row, files)
    expect(work.visibility).to eq("restricted")
    expect(work.file_sets.first.visibility).to eq("restricted")
    expect(work.file_sets.second.visibility).to eq("restricted")
    expect(work.file_sets.third.visibility).to eq("restricted")
  end

  it "Complex Import: Creates on GenericWork with 3 FileSets make visibility Restricted and the Work itself Open" do
    batch_import = described_class.new(import2, user)
    row = ["images", "Halls", "Collection of Halls", "building", "osu", nil, "open", "university", "archive", "50 x 25 cm", "paper", nil, nil, "Bartos, Chris", "1"]
    current_row = 1
    files = [{ filename: "179.jpg", title: "Dreese", visibility: "restricted" }, { filename: "181.jpg", title: "Hayes", visibility: "restricted" }, { filename: "209.jpg", title: "Orton", visibility: "restricted" }]

    work = batch_import.import_item(row, current_row, files)
    expect(work.visibility).to eq("open")
    expect(work.file_sets.first.visibility).to eq("restricted")
    expect(work.file_sets.second.visibility).to eq("restricted")
    expect(work.file_sets.third.visibility).to eq("restricted")
  end

  it "Complex Import: Creates on GenericWork with 3 FileSets make visibility open and the Work itself Restricted" do
    batch_import = described_class.new(import2, user)
    row = ["images", "Halls", "Collection of Halls", "building", "osu", nil, "restricted", "university", "archive", "50 x 25 cm", "paper", nil, nil, "Bartos, Chris", "1"]
    current_row = 1
    files = [{ filename: "179.jpg", title: "Dreese", visibility: "open" }, { filename: "181.jpg", title: "Hayes", visibility: "open" }, { filename: "209.jpg", title: "Orton", visibility: "open" }]

    work = batch_import.import_item(row, current_row, files)
    expect(work.visibility).to eq("restricted")
    expect(work.file_sets.first.visibility).to eq("open")
    expect(work.file_sets.second.visibility).to eq("open")
    expect(work.file_sets.third.visibility).to eq("open")
  end

  it "Complex Import: Creates on GenericWork with 3 FileSets make visibility '' and the Work itself Restricted" do
    batch_import = described_class.new(import2, user)
    row = ["images", "Halls", "Collection of Halls", "building", "osu", nil, "restricted", "university", "archive", "50 x 25 cm", "paper", nil, nil, "Bartos, Chris", "1"]
    current_row = 1
    files = [{ filename: "179.jpg", title: "Dreese", visibility: "" }, { filename: "181.jpg", title: "Hayes", visibility: "" }, { filename: "209.jpg", title: "Orton", visibility: "" }]

    work = batch_import.import_item(row, current_row, files)
    expect(work.visibility).to eq("restricted")
    expect(work.file_sets.first.visibility).to eq("restricted")
    expect(work.file_sets.second.visibility).to eq("restricted")
    expect(work.file_sets.third.visibility).to eq("restricted")
  end

  it "Complex Import: Creates on GenericWork with 3 FileSets make visibility open" do
    batch_import = described_class.new(import2, user)
    row = ["images", "Halls", "Collection of Halls", "building", "osu", nil, "open", "university", "archive", "50 x 25 cm", "paper", nil, nil, "Bartos, Chris", "1"]
    current_row = 1
    files = [{ filename: "179.jpg", title: "Dreese" }, { filename: "181.jpg", title: "Hayes" }, { filename: "209.jpg", title: "Orton" }]

    work = batch_import.import_item(row, current_row, files)
    expect(work.visibility).to eq("open")
    expect(work.file_sets.first.visibility).to eq("open")
    expect(work.file_sets.second.visibility).to eq("open")
    expect(work.file_sets.third.visibility).to eq("open")
  end

  it "Complex Import: Creates on GenericWork with 3 FileSets make visibility open when ''" do
    batch_import = described_class.new(import2, user)
    row = ["images", "Halls", "Collection of Halls", "building", "osu", nil, "", "university", "archive", "50 x 25 cm", "paper", nil, nil, "Bartos, Chris", "1"]
    current_row = 1
    files = [{ filename: "179.jpg", title: "Dreese" }, { filename: "181.jpg", title: "Hayes" }, { filename: "209.jpg", title: "Orton" }]

    work = batch_import.import_item(row, current_row, files)
    expect(work.visibility).to eq("open")
    expect(work.file_sets.first.visibility).to eq("open")
    expect(work.file_sets.second.visibility).to eq("open")
    expect(work.file_sets.third.visibility).to eq("open")
  end

  it "Complex Import: Creates on GenericWork with 3 FileSets make visibility open when nil" do
    batch_import = described_class.new(import2, user)
    row = ["images", "Halls", "Collection of Halls", "building", "osu", nil, nil, "university", "archive", "50 x 25 cm", "paper", nil, nil, "Bartos, Chris", "1"]
    current_row = 1
    files = [{ filename: "179.jpg", title: "Dreese" }, { filename: "181.jpg", title: "Hayes" }, { filename: "209.jpg", title: "Orton" }]

    work = batch_import.import_item(row, current_row, files)
    expect(work.visibility).to eq("open")
    expect(work.file_sets.first.visibility).to eq("open")
    expect(work.file_sets.second.visibility).to eq("open")
    expect(work.file_sets.third.visibility).to eq("open")
  end

  it "Complex Import: Get pid, cid, and title from row" do
    batch_import = described_class.new(import2, user)

    row = ["images", "Halls", "Collection of Halls", "building", "osu", nil, "restricted", "university", "archive", "50 x 25 cm", "paper", nil, nil, "Bartos, Chris", "1", nil]

    cid = batch_import.instance_eval { get_cid_from(row) }
    pid = batch_import.instance_eval { get_pid_from(row) }
    title = batch_import.instance_eval { get_title_from(row) }

    expect(cid).to eq(nil)
    expect(pid).to eq("1")
    expect(title).to eq("Halls")
  end

  it "Complex Import: Get visibility from row" do
    batch_import = described_class.new(import2, user)

    row = ["images", "Halls", "Collection of Halls", "building", "osu", nil, "restricted", "university", "archive", "50 x 25 cm", "paper", nil, nil, "Bartos, Chris", "1", nil]

    visibility = batch_import.instance_eval { get_visibility_from(row) }

    expect(visibility).to eq("restricted")
  end

  it "allows subject containing commas" do
    batch_import = described_class.new(import1, user)

    row = ["image", "Dreese", "Dreese Hall photo", "building", "osu", nil, "restricted", "foo, bar", "another subject", "50 x 25 cm", "paper", nil, "179.jpg", "Bartos, Chris", nil]
    current_row = 1
    files = [{ filename: "181.jpg", title: "Hayes" }]

    work = batch_import.import_item(row, current_row, files)
    expect(work.subject).to include('foo, bar', 'another subject')
  end

  it "doesn't run when key is 'visibility_level'" do
    batch_import = described_class.new(import1, user)
    row = ["image", "Dreese", "Dreese Hall photo", "building", "osu", nil, "restricted", "foo, bar", "another subject", "50 x 25 cm", "paper", nil, "179.jpg", "Bartos, Chris", nil]
    field_mappings = import1.import_field_mappings.where('import_field_mappings.key != ?', 'image_filename')
    generic_work = GenericWork.new

    expect { batch_import.instance_eval { process_field_mappings(row, field_mappings, generic_work) }}.not_to raise_error
  end
end
