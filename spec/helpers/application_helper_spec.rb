require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe 'login_strategy' do
    it 'returns the shibboleth authentication path in production' do
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('production'))
      expect(helper.login_strategy).to be :shibboleth
    end

    it 'returns the developer authentication path when not in production' do
      expect(helper.login_strategy).to be :developer
    end
  end

  describe 'title_for' do
    context 'a model with a name' do
      let(:model) { build(:import, name: 'My Import') }

      it 'returns the model name' do
        expect(helper.title_for(model)).to eq model.name
      end
    end

    context 'a model with no name' do
      let(:model) { build(:import, name: nil) }

      it 'returns "Untitled"' do
        expect(helper.title_for(model)).to eq 'Untitled'
      end
    end

    context 'with a property other than name' do
      let(:model) { build(:user) }

      it 'returns the value of that property' do
        expect(helper.title_for(model, :email)).to eq model.email
      end
    end
  end

  describe 'permissions_object_for' do
    context 'a presenter' do
      let(:ability) { double }
      let(:generic_work) { build(:generic_work) }
      let(:solr_document) { SolrDocument.new(generic_work.to_solr) }
      let(:object) { Sufia::WorkShowPresenter.new(solr_document, ability) }

      it 'returns the Solr document' do
        expect(helper.permissions_object_for(object)).to eq solr_document
      end
    end

    context 'an ActiveFedora object' do
      let(:object) { build(:file_set) }

      it 'returns the passed object' do
        expect(helper.permissions_object_for(object)).to be object
      end
    end
  end
end
