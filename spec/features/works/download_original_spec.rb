require 'rails_helper'

RSpec.feature 'Download original image' do
  let(:unit) { create(:unit) }
  let(:generic_work) { create(:generic_work, :without_validations, unit: unit.key) }

  context 'as an anonymous user' do
    scenario 'the download link is not visible' do
      visit curation_concerns_generic_work_path generic_work
      expect(page).not_to have_content 'Download the full-sized image'
    end
  end
end
