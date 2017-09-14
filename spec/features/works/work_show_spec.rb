require 'rails_helper'

RSpec.feature 'Work show' do
  let(:generic_work) { create(:public_generic_work, :with_image, :without_validations) }

  scenario "It has image metadata" do
    visit curation_concerns_generic_work_path generic_work
    expect(page).to have_content 'An image'
  end

  scenario "It has orcid metadata", js: true do
    visit curation_concerns_generic_work_path generic_work
    expect(page).to have_content 'Test orcid'
  end
end
