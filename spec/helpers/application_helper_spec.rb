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
end
