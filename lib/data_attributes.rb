require 'active_support/concern'
require 'active_support/inflector'
require 'active_support/json'

lib_path = "#{__dir__}/data_attributes"

require "#{lib_path}/model"
require "#{lib_path}/view"
