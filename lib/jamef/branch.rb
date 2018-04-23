require 'ostruct'
require 'active_model'

module Jamef
  class Branch < OpenStruct
    
    include ActiveModel::Validations
    
    validates :id, :code, :initials, :location, presence: true
    
    def self.branches
      @branches ||= {}
    end
    
    def self.find id
      raise ArgumentError, 'Id must be a String or Symbol' unless id.class.in?([Symbol, String])
      branches[id.to_sym]
    end
    
    def self.create branch_hash
      raise(ArgumentError,'branch_hash should be a hash. Got #{branch.class} instead.') unless branch_hash.is_a?(Hash)
      branch = new(branch_hash)
      raise("Can not create an invalid branch") unless branch.valid?
      branches.store(branch.id,branch)
      branch
    end
    
    def self.all
      branches.map{|k,v| v}
    end
    
    def self.first
      all.first
    end
    
    def self.last
      all.last
    end
    
    
    def self.populate
      [  
        { id: :aracaju, code: '31', initials: 'AJU' , location: 'Aracaju - SE' },
        { id: :barueri, code: '19', initials: 'BAR' , location: 'Barueri - SP' },
        { id: :bauru, code: '16', initials: 'BAU' , location: 'Bauru - SP' },
        { id: :belo_horizonte, code: '02', initials: 'BHZ' , location: 'Belo Horizonte - MG' },
        { id: :blumenau, code: '09', initials: 'BNU' , location: 'Blumenau - SC' },
        { id: :brasilia, code: '28', initials: 'BSB' , location: 'Brasília - DF' },
        { id: :criciuma, code: '26', initials: 'CCM' , location: 'Criciúma - SC' },
        { id: :campinas, code: '03', initials: 'CPQ' , location: 'Campinas - SP' },
        { id: :caxias_do_sul, code: '22', initials: 'CXJ' , location: 'Caxias do Sul - RS' },
        { id: :curitiba, code: '04', initials: 'CWB' , location: 'Curitiba - PR' },
        { id: :divinopolis, code: '38', initials: 'DIV' , location: 'Divinópolis - MG' },
        { id: :feira_de_santana, code: '34', initials: 'FES' , location: 'Feira de Santana - BA' },
        { id: :florianopolis, code: '11', initials: 'FLN' , location: 'Florianópolis - SC' },
        { id: :fortaleza, code: '32', initials: 'FOR' , location: 'Fortaleza - CE' },
        { id: :goiania, code: '24', initials: 'GYN' , location: 'Goiânia - GO' },
        { id: :joao_pessoa, code: '36', initials: 'JPA' , location: 'João Pessoa - PB' },
        { id: :juiz_de_fora, code: '23', initials: 'JDF' , location: 'Juiz de Fora - MG' },
        { id: :joinville, code: '08', initials: 'JOI' , location: 'Joinville - SC' },
        { id: :londrina, code: '10', initials: 'LDB' , location: 'Londrina - PR' },
        { id: :manaus, code: '25', initials: 'MAO' , location: 'Manaus - AM' },
        { id: :maceio, code: '33', initials: 'MCZ' , location: 'Maceió - AL' },
        { id: :maringa, code: '12', initials: 'MGF' , location: 'Maringá - PR' },
        { id: :porto_alegre, code: '05', initials: 'POA' , location: 'Porto Alegre - RS' },
        { id: :pouso_alegre, code: '27', initials: 'PSA' , location: 'Pouso Alegre - MG' },
        { id: :ribeirao_preto, code: '18', initials: 'RAO' , location: 'Ribeirão Preto - SP' },
        { id: :recife, code: '30', initials: 'REC' , location: 'Recife - PE' },
        { id: :rio_de_janeiro, code: '06', initials: 'RIO' , location: 'Rio de Janeiro - RJ' },
        { id: :sao_paulo, code: '07', initials: 'SAO' , location: 'São Paulo - SP' },
        { id: :sao_jose_dos_campos, code: '21', initials: 'SJK', location: 'São José dos Campos - SP' },
        { id: :sao_jose_do_rio_preto, code: '20', initials: 'SJP', location: 'São José do Rio Preto - SP' },
        { id: :salvador, code: '29', initials: 'SSA', location: 'Salvador - BA' },
        { id: :uberlandia, code: '17', initials: 'UDI', location: 'Uberlândia - MG' },
        { id: :vitoria_da_conquista, code: '39', initials: 'VDC', location: 'Vitória da Conquista - BA' },
        { id: :vitoria, code: '14', initials: 'VIX', location: 'Vitória - ES' }
      ].each {|branch| create(branch) }
    end
    
    populate
    
  end
end