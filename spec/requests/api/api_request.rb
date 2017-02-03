require 'rails_helper'

RSpec.shared_examples_for "api_request" do
  it 'respomds to JSON requests' do
    get path + '.json'
    expect(response).to be_success
    expect(response.content_type).to eq("application/json")
  end

  it 'respomds to XML requests' do
    get path + '.xml'
    expect(response).to be_success
    expect(response.content_type).to eq("application/xml")
  end
end
