require 'active_model'

module Jamef
  module Rating
    
    class Params < OpenStruct
      include ActiveModel::Validations
    end
    
  end
end