require 'site'
require 'iis_object'
require 'process_model'

module IISConfig

  class AppPool < IISObject

    def initialize
      @pipeline_mode = :Classic
      @runtime_version = :'v2.0'
      @sites = []
      @process_model = ProcessModel.new
      @enable_32bit_app_on_win64 = false
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

    def enable_32bit_app_on_win64(value = true)
      @enable_32bit_app_on_win64 = value
    end

    def process_model
      yield @process_model
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

    def build_commands
      commands = []

      commands << delete if exist? :apppool, @name
      commands << add
      @process_model.settings.each do |d|
        commands << %W{set config /section:applicationPools /[name='#{@name}'].processModel.#{d[:key]}:#{d[:value]}}
      end
      commands << %W{set apppool /apppool.name:#{@name} /enable32BitAppOnWin64:#{@enable_32bit_app_on_win64}}

      @sites.each do |s|
        commands += s.build_commands
        commands << %W{set site /site.name:#{s.name} /[path='/'].applicationPool:#{@name}}
      end

      commands
    end

    private

    def add_instance(collection, type, block)
      instance = type.new
      collection << instance
      block.call instance if block
    end

  end
  
end