require 'savon'
require 'date'
require_relative './rating/params'
# Bundler.require(:pry,:development)

module Jamef
  module Rating
    
    def self.custom_wsdl= wsdl
      @custom_wsdl = wsdl
    end
    
    WSDL = 'https://www.jamef.com.br/webservice/JAMW0520.apw?WSDL'
  
    def self.complete_rate params
      params = Jamef::Params.new(params)
      response = send_message(params)
      parse_response(response)
    end
    
    def self.rate params
      simplify_parsed_response(complete_rate(params))
    end
    
    def self.savon_client
      @savon_client ||= ::Savon.client do |globals|
        globals.convert_request_keys_to :upcase
        globals.headers({ 'X-Forwarded-Scheme' => 'https'})
        globals.wsdl wsdl
        globals.follow_redirects true
        globals.ssl_version :TLSv1_2
      end
      @savon_client
    end
    
    private
    
    
    def self.wsdl
      @custom_wsdl || WSDL
    end
        
    def self.send_message params
      freight_response = savon_client.call(:jamw0520_05, message: params.freight_hash)
      delivery_response = savon_client.call(:jamw0520_04, message: params.delivery_hash)
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
          success: true,
          error: false,
          freight: freight,
          min_delivery_date: min_date,
          max_delivery_date: max_date 
        }
      else
        { error: get_error(parsed_response), success: false }
      end
    end
    
    def self.successful_response? parsed_response
      parsed_response[:freight][:msgerro] =~ (/^ok/i) and  parsed_response[:delivery][:msgerro] =~ (/^ok/i)
    end
    
    def self.get_error parsed_response
      parsed_response[:freight][:msgerro] =~ (/^ok/i) ? parsed_response[:delivery][:msgerro] : parsed_response[:freight][:msgerro]
    end
    
    
  end
end