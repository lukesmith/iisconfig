$:.push File.expand_path(File.dirname(__FILE__))

require 'gli'
require 'iisconfig/version'
require 'iisconfig/configuration'

include GLI::App

program_desc 'Configures IIS on Windows'

version IISConfig::VERSION

desc 'executes the configuration file'
command :execute, :e do |c|
  c.desc 'Only recycle the application pools'
  c.switch :'recycle-apppools'

  c.desc 'Dry run'
  c.switch :'dry-run'

  c.desc 'Verbose'
  c.switch :'verbose'

  c.action do |global_options, options, args|
    opts = {}
    opts[:recycle_apppools] = true if options[:'recycle-apppools']

    IISConfig::IISConfiguration.dry_run = true if options[:'dry-run']
    IISConfig::IISConfiguration.verbose = true if options[:'verbose']

    config = IISConfig::IISConfiguration.new opts

    file = args[0]
    if file.nil?
      puts 'No file specified to execute'
    else
      config.load file
      config.run
    end
  end
end
