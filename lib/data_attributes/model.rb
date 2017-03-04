module DataAttributes

  module Model

    extend ActiveSupport::Concern

    class_methods do

      def data_attribute(*attributes)
        attributes = (__data_attributes + attributes).flatten.map(&:to_sym).uniq
        class_eval(%Q{
          class << self
            private

            def __data_attributes
              #{attributes.inspect}
            end
          end
        })
      end

      def data_attributes
        super_attributes = superclass && superclass.respond_to?(:__data_attributes, true) ? superclass.send(:__data_attributes) : []
        (super_attributes + __data_attributes).uniq.sort
      end

      private

      def __data_attributes
        []
      end

    end

    def data_attributes
      {}.tap do |attributes|
        self.class.data_attributes.each do |attribute|
          attributes[attribute] = send(attribute) if respond_to?(attribute, true)
        end
      end
    end

  end

end
