require 'active_support/concern'
require 'active_support/inflector'
require 'active_support/json'

lib_path = "#{__dir__}/data_attributes"

require "#{lib_path}/model"
require "#{lib_path}/helper"

ActiveSupport.on_load(:action_view) do
  include DataAttributes::Helper
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.send(:include, DataAttributes::Model)
end
