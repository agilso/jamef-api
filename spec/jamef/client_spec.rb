require 'spec_helper'

RSpec.describe Jamef::Client do
  
  let(:client)  { Jamef::Client.new(document: '000', user: 'Some City', city: 'Some Value', state: 'SP', jamef_branch: :campinas)}
  
  it 'has a valid "factory"' do
    expect(client).to be_valid
  end
  
  [:document, :user, :city, :state, :jamef_branch].each do |field|
    it "is invalid without #{field}" do
      client.send("#{field}=",nil)
      expect(client).not_to be_valid
    end
  end
  
  it 'is invalid unless state is a two digit string' do
    client.state = 'abc'
    expect(client).to be_invalid
    client.state = 'x'
    expect(client).to be_invalid
  end
  
  it 'is invalid unless its jamef_branch exists' do
    client.jamef_branch = :unknown_chuck_norris_branch
    expect(client).to be_invalid
  end
  
  it 'raises an error if not initialized properly (valid)' do
    hash = client.to_h
    expect(Jamef::Client.new(hash)).to be_valid
    expect {
      Jamef::Client.new
    }.to raise_error ArgumentError
    expect {
      Jamef::Client.new(hash.merge(jamef_branch: :unknown_chuck_norris_branch))
    }.to raise_error ArgumentError
    expect {
      Jamef::Client.new(hash.merge(state: 'Sao Paulo'))
    }.to raise_error ArgumentError
  end
  
end