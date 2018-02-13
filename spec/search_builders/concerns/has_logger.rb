require 'rails_helper'

RSpec.shared_examples_for "has_logger" do
  describe "#logger" do
    it 'returns the Rails logger instance' do
      expect(subject.logger).to be Rails.logger
    end
  end
end
