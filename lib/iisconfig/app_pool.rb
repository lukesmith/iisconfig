require 'site'

module IISConfig

  class AppPool

    def initialize
      @pipeline_mode = :Classic
      @runtime_version = :'v2.0'
      @sites = []
    end

    def name(name = nil)
      @name = name unless name.nil?
      @name
    end

    def runtime_version(version = nil)
      @runtime_version = version unless version.nil?
      @runtime_version
    end

    def pipeline_mode(mode = nil)
      @pipeline_mode = mode unless mode.nil?
      @pipeline_mode
    end

    def site(&block)
      add_instance(@sites, IISConfig::Site, block)
    end

    def sites
      @sites
    end

    def delete
      %W{DELETE apppool #{@name}}
    end

    def add
      args = []
      args << 'ADD'
      args << 'apppool'
      args << "/name:#{@name}"
      args << "/managedRuntimeVersion:#{@runtime_version}"
      args << "/managedPipelineMode:#{pipeline_mode}"
      args
    end

    private

    def add_instance(collection, type, block)
      instance = type.new
      collection << instance
      block.call instance if block
    end

  end
  
end