require File.expand_path("#{__dir__}/../lib/data_attributes")
require 'action_view'
require 'active_model'
require 'byebug'

# Support
require "#{__dir__}/support/mocks/content"
require "#{__dir__}/support/mocks/article"
require "#{__dir__}/support/mocks/category"

RSpec.configure do |config|
  config.raise_errors_for_deprecations!

  config.before(:each) do
    [Article, Category, Content].each do |mock_class|
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
