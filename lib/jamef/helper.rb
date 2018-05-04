module Jamef
  module Helper
    
    ACCENTS_MAPPING = {
    'E' => [200,201,202,203],
    'e' => [232,233,234,235],
    'A' => [192,193,194,195,196,197],
    'a' => [224,225,226,227,228,229,230],
    'C' => [199],
    'c' => [231],
    'O' => [210,211,212,213,214,216],
    'o' => [242,243,244,245,246,248],
    'I' => [204,205,206,207],
    'i' => [236,237,238,239],
    'U' => [217,218,219,220],
    'u' => [249,250,251,252],
    'N' => [209],
    'n' => [241],
    'Y' => [221],
    'y' => [253,255],
    'AE' => [306],
    'ae' => [346],
    'OE' => [188],
    'oe' => [189]
  }


    # Remove the accents from the string. Uses String::ACCENTS_MAPPING as the source map.
    def self.unaccent string
      str = string.dup
        ACCENTS_MAPPING.each {|letter,accents|
        packed = accents.pack('U*')
        rxp = Regexp.new("[#{packed}]", nil)
        str.gsub!(rxp, letter)
      }
      str
    end
      
    def self.only_numbers string
      string.gsub(/\D*/,'')
    end
    
    def self.format_decimal value
      sprintf('%.2f', Float(value))
    end
    
    def self.format_zip value
      only_numbers(value)
    end
    
    def self.format_city value
      unaccent(value).upcase
    end
    
    def self.format_state value
      value.upcase
    end
    
    def self.format_document value
      only_numbers(value)
    end
    
    
    def self.format_date value
      value.strftime("%d/%m/%Y")
    end
    
    def self.format_time value
      value.strftime("%H:%M")
    end
    
    def self.format_boolean value
      value ? 'S' : 'N'
    end
    
    def self.parse_date value
      Date.strptime(value, '%d/%m/%y')
    end
    
    def self.parse_decimal value
      Float(value)
    end
    
  end
  
end
