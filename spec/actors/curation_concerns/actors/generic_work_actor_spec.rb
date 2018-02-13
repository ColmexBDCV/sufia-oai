require 'rails_helper'

RSpec.describe CurationConcerns::Actors::GenericWorkActor do
  # Simply tests that the class inherits from CC base actor because we do not
  # have any custom functionality.
  it { expect(described_class).to be < CurationConcerns::Actors::BaseActor }
end
