require 'spec_helper'

RSpec.describe Jamef::Params do
  
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
  
  let!(:params) {
    Jamef::Params.new({ sender: sender, package: package, receiver: receiver, shipping_in: Date.new(2986,07,20).midday, service_type: :road })
  }
  
  subject { params }
  
  it { is_expected.to be_valid }
  
  [:sender, :package, :receiver, :shipping_in, :service_type].each do |field|
    it "is invalid without #{field}" do
      params.send("#{field}=",nil)
      expect(params).to be_invalid
    end
  end
  
  it 'raises an error when not properly initialized' do
    expect{Jamef::Params.new}.to raise_error ArgumentError
  end
  
  it 'is invalid without a valid sender' do
    params.sender = nil
    expect(params).to be_invalid
    
    sender.document = nil
    params.sender = sender
    expect(params).to be_invalid
  end
  
  it 'is invalid without a valid package' do
    params.package = nil
    expect(params).to be_invalid
    
    package.volume = nil
    params.package = package
    expect(params).to be_invalid
  end
  
  it 'is invalid without a valid receiver' do
    params.receiver = nil
    expect(params).to be_invalid
    
    receiver.zip = nil
    params.receiver = receiver
    expect(params).to be_invalid
  end
  
  
  context 'output' do
    it 'returns a correct freight hash' do
      expect(params.freight_hash).to eq({
        tiptra: 1,
        cnpjcpf: '00000000000',
        munori: 'JUNDIAI',
        estori: 'XX',
        segprod: '000004',
        qtdvol: 1,
        peso: '5.00',
        valmer: '1000.00',
        metro3: '2.00',
        cnpjdes: '',
        filcot: '03',
        cepdes: '07060000',
      })
    end
    
    it 'returns a correct delivery hash' do
      expect(params.delivery_hash).to eq({
        tiptra: 1,
        cnpjcpf: '00000000000',
        munori: 'JUNDIAI',
        estori: 'XX',
        segprod: '000004',
        cdatini: "20/07/2986",
        chorini: "12:00",
        cnpjdes: '',
        cepdes: '07060000',
      })
    end
    
  end
  
  
  
end