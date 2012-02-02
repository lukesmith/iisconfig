$:.push File.expand_path(File.dirname(__FILE__))

require 'rexml/document'
require 'app_pool'

module IISConfig

  class IISConfiguration

    def initialize
      @app_pools = []
      @sites = []
    end

    def app_pool(&block)
      add_instance @app_pools, IISConfig::AppPool, block
    end

    def site(&block)
      add_instance @sites, IISConfig::Site, block
    end
    
    def load(path)
      instance_eval IO.read(path), path
    end

    def run
      @app_pools.each do |p|
        commands = p.build_commands
        Runner.run_commands commands
      end

      @sites.each do |p|
        commands = p.build_commands
        Runner.run_commands commands
      end
    end

    private

    def add_instance(collection, type, block)
      instance = type.new
      collection << instance
      block.call instance if block
    end

  end

end

