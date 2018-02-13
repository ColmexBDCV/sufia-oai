require 'rails_helper'

RSpec.describe RDF::OSUL do
  subject { described_class }

  it { is_expected.to respond_to(:archivalUnit) }
end
