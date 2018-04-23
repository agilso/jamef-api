require 'active_support/all'
require "jamef/version"
require "jamef/branch"
require "jamef/package"
require "jamef/client"
require 'jamef/rating'
require 'jamef/tracking'
require 'jamef/helper'

module Jamef
  
  API_VERSION = 'v1'

  def self.rate params
    Jamef::Rating.rate(params)
  end
  
  def self.track params
    Jamef::Tracking.track(params)
  end
  
  def self.api_base_url
    "http://www.jamef.com.br/frete/rest/#{API_VERSION}/"
  end

end
