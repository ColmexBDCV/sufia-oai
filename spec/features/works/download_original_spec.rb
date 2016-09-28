require 'rails_helper'

RSpec.feature 'Download an original image' do
  context 'as a member of the unit' do
    let(:unit) { create(:unit) }
    let(:user) { create(:user) }
    let(:generic_work) { create(:generic_work, :with_image, :without_validations, unit: unit.key, unit_model: unit, user: user) }
    let!(:membership) { create(:membership, unit: unit, user: user) }

    before do
      allow_any_instance_of(FileSet).to receive(:loris_id).and_return('wd/37/5w/29/wd375w296/files/ed0115bd-cff7-465d-8e62-659d08cb4ccc-version1')
      login_as user
    end

    scenario do
      visit curation_concerns_generic_work_path generic_work
      expect(page).to have_content 'Download the full-sized image'
    end
  end
end
