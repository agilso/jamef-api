require 'ostruct'
require 'active_model'

module Jamef
  
  class Receiver < OpenStruct
    
    include ActiveModel::Validations
    
    validates :zip, presence: true
    
    def initialize *args
      super
      raise ArgumentError, errors.first unless self.valid?
      self
    end
    
    def contrib?
      contrib.present?
    end
    
    
  end
end