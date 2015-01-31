$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "rspec"
require "rack/test"
require "omniauth"
require 'omniauth-param'

RSpec.configure do |config|
config.include Rack::Test::Methods
config.extend OmniAuth::Test::StrategyMacros, :type => :strategy
end
