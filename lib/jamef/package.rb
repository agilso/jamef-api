require 'ostruct'
require 'active_model'

module Jamef
  class Package < OpenStruct
    
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
    
    def self.type_map package_type
      value = {
      
        #	CONFORME NOTA FISCAL
        nf: '000004',
        
        #	LIVROS
        livros: '000005',
        
        #	ALIMENTOS INDUSTRIALIZADOS
        alimentos: '000010',
        
        #	CONFECCOES
        confeccoes: '000008',
        
        #	COSMETICOS
        comesticos: '000011',
        
        #	MATERIAL CIRURGICO
        cirugicos: '000011',
        
        #	JORNAIS / REVISTAS
        jornais: '000006',
        
        #	MATERIAL ESCOLAR
        material_escolar: '000013'
      
      }[package_type]
      value ? value : raise(ArgumentError,"Unknown Jamef Package Type: #{package_type}")
    end
    
    def price
      package_price
    end
    
    def price= value
      self.package_price = value
    end
    
  end
end