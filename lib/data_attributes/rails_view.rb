module DataAttributes

  module RailsView

    include View

    def content_tag_for_single_record(tag_name, record, prefix, options, &block)
      options, prefix = prefix, nil if prefix.is_a?(Hash)
      options ||= {}
      options[:data] ||= {}
      options[:data].reverse_merge!(record.data_attributes) if record.is_a?(DataAttributes::Model)
      options.reverse_merge!(class: record.class.model_name.singular.dasherize)
      if block.arity == 0
        content_tag(tag_name, capture(&block), options)
      else
        content_tag(tag_name, capture(record, &block), options)
      end
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
