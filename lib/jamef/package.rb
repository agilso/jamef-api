require 'ostruct'
require 'active_model'

class Jamef::Package < OpenStruct
  
  include ActiveModel::Validations
  
end