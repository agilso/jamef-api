require 'spec_helper'
require 'date'

# Faking Requests
fake_url = "http://testing.jamef.request"
fake_response = OpenStruct.new(body: {"valor": "50.00","previsao_entrega":"31/12/#{Date.today.year}"}.to_json)

RSpec.describe Jamef::Rating do
  
  let!(:sender) {
    Jamef::Sender.new({
      document: '000.000.000-00',
      city: 'Jundiaí',
      state: 'xx',
      jamef_branch: :campinas
    })
  }
  
  let!(:package) {
    Jamef::Package.new({
      weight: 5,
      package_price: 1000,
      volume: 2
    })
  }
  
  let!(:receiver) {
    Jamef::Receiver.new({
      zip: '07060-000'
    })
  }
  
  let!(:rate_hash_params) {
    { sender: sender, package: package, receiver: receiver, shipping_in: Date.new(2030,07,20).midday, service_type: :road }
  }
  
  it 'sends correct messages to Jamef soap api through Savon' do
    expect(Jamef::Rating.instance_eval{ savon_client }).to receive(:call).once.with(:jamw0520_05, { message: Jamef::Params.new(rate_hash_params).freight_hash } )
    
    expect(Jamef::Rating.instance_eval{ savon_client }).to receive(:call).once.with(:jamw0520_04, { message: Jamef::Params.new(rate_hash_params).delivery_hash } )
    begin Jamef.rate(rate_hash_params) rescue nil end
  end
  
  
end