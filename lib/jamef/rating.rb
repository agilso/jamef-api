require 'date'
require 'rest-client'
require_relative './rating/params'
Bundler.require(:pry,:development)

module Jamef
  module Rating
  
    # TO-DO: move params logic to Jamef::Rating::Params class.
    
    def self.rate params
      validate_params(params)
      hash = soap_params(params)
      response = get(hash)
      parse_response(response)
    end
    
    def self.validate_params params
      raise ArgumentError, "Expected a hash. Got #{params.class}" unless params.is_a?(Hash)
      [:client,:package,:to,:shipping_in, :service_type].each do |field|
        raise ArgumentError, "Missing :#{field} key." unless params.has_key?(field) and params[field].present?
      end
      raise ArgumentError, ":client is not a Jamef::Client" unless params[:client].is_a?(Jamef::Client)

      raise ArgumentError, ":package is not a Jamef::Package" unless params[:package].is_a?(Jamef::Package)
      true
    end
    
    def self.build_url_from_params params
      [
        # base
        Jamef.api_base_url.sub(/\/$/,''),
        
        # service type
        Jamef::Rating.service_map(params[:service_type]),
        
        # document
        params[:client].document.gsub(/\D*/,''),
        
        # origin city
        params[:client].city,
        
        # origin state
        params[:client].state,
        
        # products type
        Jamef::Package.type_map(params[:package].type),
        
        # package weight
        Jamef::Helper.format_decimal(params[:package].weight),
        
        # package price
        Jamef::Helper.format_decimal(params[:package].price),
        
        # package volume
        Jamef::Helper.format_decimal(params[:package].volume),
        
        # destination zip
        Jamef::Helper.format_zip(params[:to]),
        
        # jamef branch​
        Jamef::Branch.find((params[:branch] || params[:jamef_branch]) || params[:client].jamef_branch).code,
        
        # shipping_in date
        params[:shipping_in].strftime("%d/%m/%Y"),
        
        # user
        params[:client].user
      ].join('/')
    end
    
    def self.soap_params params
      {  
        # service type
        tiptra: Jamef::Rating.service_map(params[:service_type]),
        
        # document
        cnpjcpf: params[:client].document.gsub(/\D*/,''),
        
        # origin city
        munori: params[:client].city,
        
        # origin state
        estori: params[:client].state,
        
        # products type
        segprod: Jamef::Package.type_map(params[:package].type),
        
        # 
        qtdvol: 1,
        
        # package weight
        peso: Jamef::Helper.format_decimal(params[:package].weight),
        
        # package price
        valmer: Jamef::Helper.format_decimal(params[:package].price),
        
        # package volume
        metro3: Jamef::Helper.format_decimal(params[:package].volume),
        
        # destination zip
        cepdes: Jamef::Helper.format_zip(params[:to]),
        
        # jamef branch​
        filcot: Jamef::Branch.find((params[:branch] || params[:jamef_branch]) || params[:client].jamef_branch).code,
        
      }
    end
    
    def self.get hash
      wsdl = 'http://www.jamef.com.br/webservice/JAMW0520.apw?WSDL'
      client = Savon.client do |globals|
        globals.convert_request_keys_to :upcase
        globals.wsdl wsdl
      end
      binding.pry
    
      {"valor": "50.00","previsao_entrega":"31/12/#{Date.today.year}"}.to_json      
    end
    
    def self.parse_response response_body
      h = JSON.parse(response_body)
      price = Float(h["valor"])
      estimated_delivery_date = Date.strptime(h['previsao_entrega'], '%d/%m/%Y')
      {price: price, estimated_delivery_date: estimated_delivery_date }
    end
    
    def self.service_map service
      value = {
        road: 1,
        air: 2
      }[service.to_sym]
      value ? value : raise(ArgumentError, "Jamef #{service} service not found")
    end
    
  end
end