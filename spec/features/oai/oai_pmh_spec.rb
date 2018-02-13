require 'rails_helper'

RSpec.feature 'OAI-PMH catalog endpoint' do
  describe 'Identify verb' do
    scenario 'displays repository information' do
      visit api_oai_provider_path(verb: 'Identify')
      expect(page).to have_content('Repositorio Institucional de El Colegio de México - Biblioteca Daniel Cosío Villega')
    end
  end

  describe 'ListRecords verb' do
    before do
      create_list(:generic_work, 3, :public)
    end

    scenario 'displays all records' do
      visit api_oai_provider_path(verb: 'ListRecords', metadataPrefix: 'oai_dc')
      expect(page).to have_selector('record', count: 3)
    end

    scenario 'only displays works' do
      create(:collection, :public)

      visit api_oai_provider_path(verb: 'ListRecords', metadataPrefix: 'oai_dc')
      expect(page).to have_selector('record', count: 3)
    end
  end

  describe 'GetRecord verb' do
    let(:work) { create(:generic_work) }
    # TODO: change identifier, add orcid metadata property
    # make new context?
    let(:identifier) { "oai:repositorio.colmex.mx:dc/#{work.id}" }

    scenario 'displays a single record', js: true do
      visit api_oai_provider_path(verb: 'GetRecord', metadataPrefix: 'oai_dc', identifier: identifier)
      expect(page).to have_css('.oairecord', count: 1)
      expect(page).to have_content(identifier)
    end

    context 'rdf records' do
      scenario "a record has a creator field with all of the ids that are required" do
        visit api_oai_provider_path(verb: 'GetRecord', metadataPrefix: 'oai_dc', identifier: identifier)

        # expect(page).to have_content(new_id)
      end

      scenario "a record can display an rdf field" do
        visit api_oai_provider_path(verb: 'GetRecord', metadataPrefix: 'oai_rdf', identifier: identifier, field: orcid)

        expect(page).to have_content(new_id)
      end
    end

    context 'when record has a handle' do
      let(:work) { create(:generic_work, handle: ['1234/abcdef'], identifier: ['anid']) }

      scenario 'displays the handle and identifier' do
        visit api_oai_provider_path(verb: 'GetRecord', metadataPrefix: 'oai_dc', identifier: identifier)
        expect(page).to have_content('http://hdl.handle.net/1234/abcdef')
        expect(page).to have_content('anid')
      end
    end
  end

  describe 'ListSets verb' do
    scenario 'shows a set for each unit' do
      create(:unit)
      create(:unit, key: 'foo', name: 'Foo')

      visit api_oai_provider_path(verb: 'ListSets')
      expect(page).to have_selector('set', count: 2)
    end
  end

  describe 'ListMetadataFormats verb' do
    scenario 'lists the oai_dc format' do
      visit api_oai_provider_path(verb: 'ListMetadataFormats')
      expect(page).to have_content('oai_dc')
    end
  end

  describe 'ListIdentifiers verb' do
    scenario 'lists identifiers for works' do
      work1 = create(:generic_work, :public)
      work2 = create(:generic_work, :public)

      visit api_oai_provider_path(verb: 'ListIdentifiers', metadataPrefix: 'oai_dc')
      expect(page).to have_content(work1.id)
      expect(page).to have_content(work2.id)
    end
  end
end
