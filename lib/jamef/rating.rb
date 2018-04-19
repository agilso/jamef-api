require 'date'
require 'rest-client'
require_relative './rating/params'

module Jamef::Rating
  
  # TO-DO: move params logic to Jamef::Rating::Params class.
  
  def self.rate params
    validate_params(params)
    url = build_url_from_params(params)
    response = get(url)
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
      params[:client].document,
      
      # origin city
      params[:client].city,
      
      # origin state
      params[:client].state,
      
      # products type
      Jamef::Package.code_map(params[:package].type),
      
      # package weight
      params[:package].weight,
      
      # package price
      params[:package].price,
      
      # package volume
      params[:package].volume,
      
      # destination zip
      params[:to],
      
      # jamef branch​
      ((params[:branch] || params[:jamef_branch]) || params[:client].jamef_branch),
      
      # shipping_in date
      params[:shipping_in].strftime("%d/%m/%Y"),
      
      
      # user
      params[:client].user
    ].join('/')
  end
  
  def self.get url
    begin
      RestClient.get(url).body
    rescue => error
      raise error.inspect
    end
  end
  
  def self.parse_response response_body
    h = JSON.parse(response_body)
    price = Float(h["valor"])
    estimated_delivery_date = Date.strptime(h['previsao_entrega'], '%d/%m/%Y')
    {price: price, estimated_delivery_date: estimated_delivery_date }
  end
  
end