$:.push File.expand_path(File.dirname(__FILE__))

require 'rexml/document'
require 'app_pool'

module IISConig

  class IISConfiguration

    def initialize
      @app_pools = []
    end

    def app_pool(&block)
      add_instance @app_pools, IISConfig::AppPool, block
    end
    
    def load(path)
      instance_eval IO.read(path), path
    end

    def run
      @app_pools.each do |p|
        execute_command p.delete if exists? :apppool, p.name
        execute_command p.add
      end
    end

    def exists?(type, name)
      args = []
      args << 'LIST'
      args << type.to_s
      args << '/xml'
      result = execute_command args

      exists = false
      doc = REXML::Document.new(result)

      doc.elements.each("appcmd/#{type.to_s.upcase}[@#{type.to_s.upcase}.NAME='#{name}']") do
        exists = true
      end

      exists
    end

    private

     def add_instance(collection, type, block)
      instance = type.new
      collection << instance
      block.call instance if block
    end

    def execute_command(args)
      args.flatten!
      tool = :appcmd

      puts  "  #{tool.to_s} #{args.join(' ')}"
      result = `c:/windows/system32/inetsrv/appcmd #{args.join(' ')}`
      raise Exception.new($?.exitstatus) unless result
      result
    end

  end

end

