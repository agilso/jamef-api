module Jamef::Rating
  
  def self.validate_consultation_params params
    raise ArgumentError, "Expected a hash. Got #{params.class}" unless params.is_a?(Hash)
    [:client,:package,:to,:shipping_in].each do |field|
      raise ArgumentError, "Missing :#{field} key." unless params.has_key?(field)
    end
  end
  
end