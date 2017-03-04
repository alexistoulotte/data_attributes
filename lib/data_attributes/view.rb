module DataAttributes

  module View

    def data_attribute_value(value, options = {})
      if value.is_a?(String) || value.is_a?(Symbol)
        options[:prefix_strings] ? "string:#{value}" : value.to_s
      elsif value.is_a?(Numeric)
        value
      elsif value.nil?
        nil
      elsif value.is_a?(Time)
        value.to_i
      elsif value.is_a?(TrueClass) || value.is_a?(FalseClass)
        options[:raw] ? value : value.to_s
      elsif value.is_a?(Array)
        value = value.map { |v| data_attribute_value(v, options.merge(raw: true)) }
        options[:raw] ? value : value.to_json
      elsif value.is_a?(Hash)
        value = value.each_with_object({}) { |(k, v), hash| hash[k.to_s.gsub(/^_+/, '').gsub(/\?$/, '').camelize(:lower)] = data_attribute_value(v, options.merge(raw: true)) }
        options[:raw] ? value : value.to_json
      elsif value.is_a?(DataAttributes::Model)
        data_attribute_value(value.data_attributes, options)
      else
        raise "Can't convert object of class #{value.class} in data attributes"
      end
    end

  end

end
