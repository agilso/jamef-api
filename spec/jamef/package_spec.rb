require 'spec_helper'

RSpec.describe Jamef::Package do
  let(:package)  { Jamef::Package.new(weight: 5, user: 'a_jamef_user', package_price: 1000, volume: 5) }
  
  it 'has a valid "factory"' do
    expect(package).to be_valid
  end
  
  it 'type is :nf by default' do
    expect(package.type).to eq :nf
  end
  
  [:weight, :package_price, :volume, :type].each do |field|
    it "is invalid without #{field}" do
      package.send("#{field}=",nil)
      expect(package).not_to be_valid
    end
  end
  
  it 'raises an error if not initialized properly (valid)' do
    hash = package.to_h
    expect(Jamef::Package.new(hash)).to be_valid
    expect {
      Jamef::Package.new
    }.to raise_error ArgumentError
    expect {
      Jamef::Package.new hash.merge(type: :unknown_chuck_norris_type)
    }.to raise_error ArgumentError
  end
end