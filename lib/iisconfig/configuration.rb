$:.push File.expand_path(File.dirname(__FILE__))

require 'rexml/document'
require 'app_pool'
require 'ftp_site'
require 'site'

module IISConfig

  class IISConfiguration
    @@dry_run = false

    def initialize(options = {})
      @options = {recycle_apppools: false}.merge(options)
      @app_pools = []
      @sites = []
      @ftp_sites = []
      @before = []
      @after = []
    end

    def self.dry_run=dry_run
      @@dry_run = dry_run
    end

    def self.dry_run?
      @@dry_run
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

      if @options[:recycle_apppools]
        recycle_application_pools
      else
        rebuild_all
      end

      @after.each { |a| a.call }
    end

    private

    def rebuild_all
      execute @app_pools
      execute @sites
      execute @ftp_sites
    end

    def recycle_application_pools
      @app_pools.each do |p|
        commands = p.recycle
        Runner.run_commands [commands] unless commands.empty?
      end
    end

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

