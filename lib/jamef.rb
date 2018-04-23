require 'active_support/all'
require "jamef/version"
require "jamef/branch"
require "jamef/package"
require "jamef/sender"
require "jamef/receiver"
require "jamef/params"
require 'jamef/rating'
require 'jamef/tracking'
require 'jamef/helper'

module Jamef

  def self.rate params
    Jamef::Rating.rate(params)
  end
  
  def self.quick_rate params
    Jamef::Rating.quick_rate(params)
  end
  
  def self.track params
    Jamef::Tracking.track(params)
  end

end
