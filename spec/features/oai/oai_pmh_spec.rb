require 'rails_helper'

RSpec.feature 'OAI-PMH catalog endpoint' do
  describe 'Identify verb' do
    scenario 'displays repository information' do
      visit oai_provider_catalog_path(verb: 'Identify')
      expect(page).to have_content('The Ohio State University Libraries Digital Collections')
    end
  end

  describe 'ListRecords verb' do
    scenario 'displays all records' do
      create_list(:generic_work, 3, :public)

      visit oai_provider_catalog_path(verb: 'ListRecords', metadataPrefix: 'oai_dc')
      expect(page).to have_selector('record', count: 3)
    end
  end

  describe 'GetRecord verb' do
    let(:work) { create(:generic_work) }
    let(:identifier) { "oai:library.osu.edu:dc/#{work.id}" }

    scenario 'displays a single record' do
      visit oai_provider_catalog_path(verb: 'GetRecord', metadataPrefix: 'oai_dc', identifier: identifier)
      expect(page).to have_selector('record', count: 1)
      expect(page).to have_content(identifier)
    end

    context 'when record has a handle' do
      let(:work) { create(:generic_work, handle: ['1234/abcdef'], identifier: ['anid']) }

      scenario 'displays the handle and identifier' do
        visit oai_provider_catalog_path(verb: 'GetRecord', metadataPrefix: 'oai_dc', identifier: identifier)
        expect(page).to have_content('http://hdl.handle.net/1234/abcdef')
        expect(page).to have_content('anid')
      end
    end
  end

  describe 'ListSets verb' do
    scenario 'shows that no sets exist' do
      visit oai_provider_catalog_path(verb: 'ListSets')
      expect(page).to have_content('This repository does not support sets')
    end
  end

  describe 'ListMetadataFormats verb' do
    scenario 'lists the oai_dc format' do
      visit oai_provider_catalog_path(verb: 'ListMetadataFormats')
      expect(page).to have_content('oai_dc')
    end
  end

  describe 'ListIdentifiers verb' do
    scenario 'lists identifiers for works' do
      work1 = create(:generic_work, :public)
      work2 = create(:generic_work, :public)

      visit oai_provider_catalog_path(verb: 'ListIdentifiers', metadataPrefix: 'oai_dc')
      expect(page).to have_content(work1.id)
      expect(page).to have_content(work2.id)
    end
  end
end
