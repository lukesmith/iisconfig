$:.push File.expand_path(File.dirname(__FILE__))

require 'rainbow'
require 'gli'
require 'gli_version'
require 'iisconfig/version'
require 'iisconfig/configuration'

include GLI

version IISConfig::VERSION

desc 'executes the configuration file'
command :execute, :e do |c|
  c.action do |global_options, options, args|
    config = IISConfig::IISConfiguration.new
    config.load args[0]
    config.run
  end
end



