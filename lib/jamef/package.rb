require 'ostruct'
require 'active_model'

class Jamef::Package < OpenStruct
  
  include ActiveModel::Validations
  
  PRODUCTS_TYPES = [:nf, :livros, :alimentos, :confeccoes, :comesticos, :cirugicos, :jornais, :material_escolar]
  
  validates :weight, :package_price, :volume, :type, presence: true
  validates :weight, :package_price, :volume, numericality: true
  
  validates :type, inclusion: PRODUCTS_TYPES
  
  def initialize *args
    super
    self.type ||= :nf
    raise ArgumentError, errors.first unless self.valid?
    self
  end
  
end