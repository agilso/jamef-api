require 'ostruct'
require 'active_model'

module Jamef
  
  class Sender < OpenStruct
    
    include ActiveModel::Validations
    
    validates :document, :city, :state, :jamef_branch, presence: true
    
    validates :state, length: {is: 2}
    
    validate :validate_branch
    
    def initialize *args
      super
      raise ArgumentError, errors.first unless self.valid?
      self
    end
    
    def validate_branch
      errors.add(:jamef_branch,'Unknown branch') if jamef_branch.present? and Jamef::Branch.find(jamef_branch).blank?
    end
    
  end
end