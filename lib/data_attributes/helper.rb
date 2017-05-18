module DataAttributes

  module Helper

    def self.data_attribute_value(value, options = {})
      if value.is_a?(String) || value.is_a?(Symbol)
        options[:prefix_strings] ? "string:#{value}" : value.to_s
      elsif value.is_a?(Numeric)
        value
      elsif value.nil?
        nil
      elsif value.is_a?(Time)
        value.to_i
      elsif value.is_a?(Date)
        value.strftime('%Y/%m/%d')
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

    def content_tag_for_single_record(tag_name, record, prefix, options, &block)
      options, prefix = prefix, nil if prefix.is_a?(Hash)
      options ||= {}
      options[:data] ||= {}
      options[:data] = options[:data].data_attributes if options[:data].is_a?(DataAttributes::Model)
      options[:data].reverse_merge!(record.data_attributes) if record.is_a?(DataAttributes::Model)
      options.reverse_merge!(class: record.class.model_name.singular.dasherize)
      if block.arity == 0
        content_tag(tag_name, capture(&block), options)
      else
        content_tag(tag_name, capture(record, &block), options)
      end
    end

    def data_attribute_value(value, options = {})
      DataAttributes::Helper.data_attribute_value(value, options)
    end

    def tag_options(options, escape = true)
      (options.delete(:data) || options.delete('data') || {}).each do |key, value|
        value = data_attribute_value(value)
        value = html_escape(value) if escape
        options["data-#{key.to_s.gsub(/^_+/, '').gsub(/\?$/, '').dasherize}"] = value
      end
      super
    end

  end

end
