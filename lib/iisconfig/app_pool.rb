require 'site'
require 'ftp_site'
require 'iis_object'
require 'process_model'
require 'command'

module IISConfig

  class AppPool < IISObject

    def initialize
      @pipeline_mode = :Classic
      @runtime_version = :'v2.0'
      @sites = []
      @ftp_sites = []
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

    def start_mode(value)
      @start_mode = value
      @start_mode
    end

    def process_model
      yield @process_model
    end

    def site(&block)
      add_instance(@sites, IISConfig::Site, block)
    end

    def ftp_site(&block)
      add_instance(@ftp_sites, IISConfig::FtpSite, block)
    end

    def sites
      @sites
    end

    def delete
      %W{DELETE APPPOOL #{@name}}
    end

    def add
      args = []
      args << 'ADD'
      args << 'APPPOOL'
      args << "/name:#{@name}"
      args << "/managedRuntimeVersion:#{@runtime_version}"
      args << "/managedPipelineMode:#{pipeline_mode}"
      if @start_mode
        args << "/startMode:#{@start_mode}"
      end
      args
    end

    def required_paths
      paths = []
      @sites.each do |s|
        paths += s.required_paths
      end
      paths
    end

    def recycle
      args = []
      if exist? :apppool, @name
        args << 'RECYCLE'
        args << 'APPPOOL'
        args << "/apppool.name:#{@name}"
      end
      args
    end

    def build_commands
      commands = []

      commands << delete if exist? :apppool, @name
      commands << add
      @process_model.settings.each_pair do |key, value|
        safe_command = %W{SET CONFIG /section:applicationPools /[name='#{@name}'].processModel.#{key}:#{value}}

        if value.is_a?(IISConfig::SensitiveValue)
          c = %W{SET CONFIG /section:applicationPools /[name='#{@name}'].processModel.#{key}:#{value.value}}
          commands << IISConfig::Command.new(c, safe_command)
        else
          commands << safe_command
        end
      end
      commands << %W{SET APPPOOL /apppool.name:#{@name} /enable32BitAppOnWin64:#{@enable_32bit_app_on_win64}}

      @sites.each do |s|
        s.app_pool @name.to_sym
        commands += s.build_commands
      end

      @ftp_sites.each do |s|
        s.app_pool @name.to_sym
        commands += s.build_commands
      end

      commands
    end

  end
  
end