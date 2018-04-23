require 'spec_helper'
require 'date'

# Faking Requests
fake_url = "http://testing.jamef.request"
fake_response = OpenStruct.new(body: {"valor": "50.00","previsao_entrega":"31/12/#{Date.today.year}"}.to_json)

RSpec.describe Jamef::Rating do
  
  let(:client) {
    Jamef::Sender.new({
      document: '000.000.000-00',
      city: 'Test City',
      state: 'XX',
      jamef_branch: :campinas
    })
  }
  
  let(:package) {
    Jamef::Package.new({
      weight: 5,
      package_price: 1000,
      volume: 5
    })
  }
  
  let(:valid_params) {
    { client: client, package: package, to: '07060-000', shipping_in: 3.days.from_now, service_type: :road }
  }
  # 
  # context 'service map' do
  # 
  # end

  
  # context 'soap' do
  #   before(:each) {
  #     allow(Jamef::Rating).to receive(:build_url_from_params).and_return(fake_url)
  # 
  #     allow(RestClient).to receive(:get).with(fake_url).and_return(fake_response)
  #   }
  # 
  # 
  #   it 'url is stubbed correctly' do
  #     expect(Jamef::Rating.build_url_from_params('lol')).to eq 'http://testing.jamef.request'
  #   end
  # 
  #   context 'rate' do
  #     it 'makes a http request to the jamef api' do
  #       expect(RestClient).to receive(:get).with(fake_url)
  #       Jamef::Rating.rate(valid_params)
  #     end
  # 
  #     context 'success' do
  #       it 'returns a hash' do
  #         expect(Jamef::Rating.rate(valid_params)).to eq( {price: 50.00, estimated_delivery_date: Date.today.end_of_year })
  #       end
  #     end
  # 
  #     context 'parsing' do
  # 
  #     end
  # 
  #   end
    
  # end
  
end