require 'active_support/all'
require "jamef/version"
require "jamef/branch"
require "jamef/package"
require "jamef/client"
require 'jamef/rating'
require 'jamef/tracking'

module Jamef

  def self.consult params
    Jamef::Rating.consult(params)
  end

end
