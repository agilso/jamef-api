require 'date'
require 'rest-client'
require_relative './rating/params'
Bundler.require(:pry,:development)

module Jamef
  module Rating
    
    WSDL = 'http://www.jamef.com.br/webservice/JAMW0520.apw?WSDL'
  
    def self.rate params
      params = Jamef::Params.new(params)
      response = send_message(params)
      parse_response(response)
    end
    
    def self.quick_rate params
      simplify_parsed_response(rate(params))
    end
    
    private
    
    def self.wsdl
      WSDL
    end
        
    def self.send_message params
      @client ||= Savon.client do |globals|
        globals.convert_request_keys_to :upcase
        globals.wsdl wsdl
      end
      freight_response = @client.call(:jamw0520_05, message: params.freight_hash)
      delivery_response = @client.call(:jamw0520_04, message: params.delivery_hash)
      {freight: freight_response, delivery: delivery_response}
    end
    
    def self.parse_response response
      {freight: parse_freight_response(response), delivery: parse_delivery_response(response)}
    end
    
    def self.parse_freight_response response
      response[:freight].body.to_h[:jamw0520_05_response][:jamw0520_05_result]
    end
    
    def self.parse_delivery_response response
      response[:delivery].body.to_h[:jamw0520_04_response][:jamw0520_04_result]
    end
    
    
    def self.simplify_parsed_response parsed_response
      if successful_response?(parsed_response)
        freight = Jamef::Helper.parse_decimal(parsed_response[:freight][:valfre][:avalfre].last[:total])
        min_date = Jamef::Helper.parse_date(parsed_response[:delivery][:cdtmin])
        max_date = Jamef::Helper.parse_date(parsed_response[:delivery][:cdtmax])
        {
          freight: freight,
          min_delivery_date: min_date,
          max_delivery_date: max_date 
        }
      else
        binding.pry
        { error: (parsed_response[:freight][:msgerro] || parsed_response[:delivery][:msgerro]) }
      end
    end
    
    def self.successful_response? parsed_response
      parsed_response[:freight][:msgerro].match?(/^ok/i) and  parsed_response[:delivery][:msgerro].match?(/^ok/i)
    end
    
    
  end
end