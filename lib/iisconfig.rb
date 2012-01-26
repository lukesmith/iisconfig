$:.push File.expand_path(File.dirname(__FILE__))
require 'iisconfig/configuration.rb'

args = ARGV.dup

config = IISConfig::IISConfiguration.new
config.load args[0]
config.run