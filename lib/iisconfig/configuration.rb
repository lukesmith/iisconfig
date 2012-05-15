$:.push File.expand_path(File.dirname(__FILE__))

require 'rexml/document'
require 'app_pool'
require 'ftp_site'
require 'site'

module IISConfig

  class IISConfiguration

    def initialize
      @app_pools = []
      @sites = []
      @ftp_sites = []
      @before = []
      @after = []
    end

    def app_pool(&block)
      add_instance @app_pools, IISConfig::AppPool, block
    end

    def site(&block)
      add_instance @sites, IISConfig::Site, block
    end

    def ftp_site(&block)
      add_instance @ftp_sites, IISConfig::FtpSite, block
    end

    def before(&block)
      @before << block
    end

    def after(&block)
      @after << block
    end
    
    def load(path)
      instance_eval IO.read(path), path
    end

    def run
      @before.each { |a| a.call }

      execute @app_pools
      execute @sites
      execute @ftp_sites

      @after.each { |a| a.call }
    end

    private

    def execute(objects)
      objects.each do |p|
        commands = p.build_commands
        Runner.run_commands commands

        p.required_paths.each do |path|
          FileUtils.mkdir_p path unless Dir.exist? path
        end
      end
    end

    def add_instance(collection, type, block)
      instance = type.new
      collection << instance
      block.call instance if block
    end

  end

end

