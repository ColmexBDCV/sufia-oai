require 'rails_helper'

RSpec.describe OaiController, type: :controller do
  describe '#search_builder_class' do
    subject { described_class.new.search_builder_class }
    it { is_expected.to eq OaiSearchBuilder }
  end
end
