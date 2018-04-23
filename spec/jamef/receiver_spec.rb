require 'spec_helper'

RSpec.describe Jamef::Receiver do
  let(:receiver)  { Jamef::Receiver.new(zip: 'xxxxxxxx') }
  
  it 'has a valid "factory"' do
    expect(receiver).to be_valid
  end
  
  
  [:zip].each do |field|
    it "is invalid without #{field}" do
      receiver.send("#{field}=",nil)
      expect(receiver).not_to be_valid
    end
  end
  
end