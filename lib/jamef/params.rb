require 'ostruct'
require 'active_model'

module Jamef
  class Params < OpenStruct
    
    include ActiveModel::Validations
    
    validates :sender, :package, :receiver, :shipping_in, :service_type, presence: true
    
    validates :service_type, inclusion: [:road,:air]
    
    validate :validate_sender
    validate :validate_receiver
    validate :validate_package
    
    # validates :tiptra, :cnpjcpf, :munori, :estori, :segprod, :qtdvol, :peso, :valmer, :metro3, :cepdes, :filcot, presence: true
    
    def initialize *args
      super
      
      raise ArgumentError, errors.full_messages.join("\n") unless self.valid?
      self
    end
    
    def freight_hash
      hash = {}
      hash.store(:tiptra, tiptra)
      hash.store(:cnpjcpf, cnpjcpf)
      hash.store(:munori, munori)
      hash.store(:estori, estori)
      hash.store(:segprod, segprod)
      hash.store(:qtdvol, qtdvol)
      hash.store(:peso, peso)
      hash.store(:valmer, valmer)
      hash.store(:metro3, metro3)
      hash.store(:cnpjdes, cnpjdes)
      hash.store(:filcot, filcot)
      hash.store(:cepdes, cepdes)
      hash.store(:contrib, contrib) if contrib?
      hash
    end
    
    def delivery_hash
      hash = {}
      hash.store(:tiptra, tiptra)
      hash.store(:munori, munori)
      hash.store(:estori, estori)
      hash.store(:cnpjcpf, cnpjcpf)
      hash.store(:segprod, segprod)
      hash.store(:cdatini, cdatini)
      hash.store(:chorini, chorini)
      hash.store(:cnpjdes, cnpjdes)
      hash.store(:cepdes, cepdes)
      hash
    end
    
    private
    
    # service type
    def tiptra
      service_code
    end
        
    # document
    def cnpjcpf
      Jamef::Helper.format_document(sender.document)
    end
        
    # origin city
    def munori
      Jamef::Helper.format_city(sender.city)
    end
        
    # origin state
    def estori
      Jamef::Helper.format_state(sender.state)
    end
        
    # products type
    def segprod
      Jamef::Package.type_map(package.type)
    end
        
    # volumes quantity
    def qtdvol
      package.quantity || 1
    end
        
    # package weight
    def peso
      Jamef::Helper.format_decimal(package.weight)
    end
        
    # package price
    def valmer
      Jamef::Helper.format_decimal(package.price)
    end
        
    # package volume
    def metro3
      Jamef::Helper.format_decimal(package.volume)
    end
        
    # destination zip
    def cepdes
      Jamef::Helper.format_zip(receiver.zip)
    end
        
    # jamef branch​
    def filcot
      Jamef::Branch.find((branch || jamef_branch) || sender.jamef_branch).code
    end
        
    # contrib! pays icms? tem inscrição estadual?
    def contrib
      Jamef::Helper.format_boolean(receiver.contrib)
    end
    
    def contrib?
      receiver.contrib.present? and receiver.contrib
    end
        
    # receiver document
    def cnpjdes
      receiver.document.present? ? Jamef::Helper.format_document(receiver.document) : ''
    end
    
    # shipping date
    def cdatini
      Jamef::Helper.format_date(shipping_in)
    end
    
    # shipping time
    def chorini
      Jamef::Helper.format_time(shipping_in)
    end
  
    # service type map
    def service_code
      value = {
        road: 1,
        air: 2
      }[service_type]
      value ? value : raise(ArgumentError, "Jamef #{service} service not found")
    end
    
    def validate_sender
      errors.add(:sender,'is not a valid Jamef::Sender') unless (sender.present? and sender.valid?)
    end
    
    def validate_receiver
      errors.add(:receiver,'is not a valid Jamef::Receiver') unless (receiver.present? and receiver.valid?)
    end
    
    def validate_package
      errors.add(:package,'is not a valid Jamef::Package') unless (package.present? and package.valid?)
    end
    
    
  end
end