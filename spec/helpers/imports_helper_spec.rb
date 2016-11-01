require 'rails_helper'

RSpec.describe ImportsHelper, type: :helper do
  let(:import) { build(:import) }

  describe "import_type_list" do
    let(:import_types) { [["Generic", "generic"]] }
    it { expect(helper.import_type_list).to eq import_types }
  end

  describe "status_icon_class_for" do
    classes = {
      'not_ready': 'glyphicon-question-sign',
      'ready': 'glyphicon-thumbs-up',
      'in_progress': 'glyphicon-time',
      'complete': 'glyphicon-ok',
      'reverting': 'glyphicon-backward',
      'final': 'glyphicon-lock'
    }

    classes.each do |status, klass|
      it "returns '#{klass}' for status '#{status}'" do
        import = build(:simple_import, status: status)
        expect(helper.status_icon_class_for(import)).to eq klass
      end
    end

    it "returns 'glyphicon-warning-sign' as a default status" do
      allow(import).to receive(:status).and_return('another')
      expect(helper.status_icon_class_for(import)).to eq 'glyphicon-warning-sign'
    end
  end

  describe "last_run_for" do
    context "an import that has been run" do
      let(:time) { Time.new(2016).utc }
      let(:import) { create(:simple_import) }
      let!(:record) { create(:imported_record, import: import, created_at: time) }

      it "shows the formatted last run time" do
        expect(helper.last_run_for(import)).to eq time.strftime('%-m/%-d/%Y %l:%M%P')
      end
    end

    context "an import that has never been run" do
      it "shows 'Never'" do
        expect(helper.last_run_for(import)).to eq "<em>Never</em>"
      end
    end
  end
end
