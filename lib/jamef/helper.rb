module Jamef
  module Helper
    
    def self.only_numbers string
      string.gsub(/\D*/,'')
    end
    
    def self.format_decimal value
      sprintf('%.2f', Float(value))
    end
    
    def self.format_zip value
      only_numbers(value)
    end
    
  end
end
