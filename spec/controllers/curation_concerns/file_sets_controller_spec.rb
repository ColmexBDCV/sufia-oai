require 'rails_helper'
require 'controllers/concerns/tombstoneable'

RSpec.describe CurationConcerns::FileSetsController, type: :controller do
  describe "modules" do
    it { is_expected.to include_module(CurationConcerns::FileSetsControllerBehavior) }
    it { is_expected.to include_module(Sufia::Controller) }
    it { is_expected.to include_module(Sufia::FileSetsControllerBehavior) }
  end

  it_behaves_like "tombstoneable" do
    let(:factory) { :file_set }
  end
end
