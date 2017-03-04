require File.expand_path("#{__dir__}/../lib/data_attributes")
require 'byebug'

# Support
require "#{__dir__}/support/mocks/content"
require "#{__dir__}/support/mocks/category"
require "#{__dir__}/support/mocks/article"
require "#{__dir__}/support/mocks/view"

RSpec.configure do |config|
  config.raise_errors_for_deprecations!

  config.before(:each) do
    [Article, Category, Content].each do |mock_class|
      next unless mock_class.respond_to?(:__data_attributes, true)
      mock_class.class_eval(%Q{
        class << self
          private

          def __data_attributes
            []
          end
        end
      })
    end
  end
end
