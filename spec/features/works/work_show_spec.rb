require 'rails_helper'

RSpec.feature 'Work show' do
  let(:generic_work) { create(:public_generic_work, :with_image, :without_validations) }

  scenario do
    visit curation_concerns_generic_work_path generic_work
    expect(page).to have_content 'An image'
  end
end
