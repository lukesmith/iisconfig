require 'iis_object'
require 'virtual_directory'

module IISConfig

  class Application < IISObject

    def name(name)
      @name = name
      @virtual_directories = []
      @app_pool = nil
    end

    def path(path)
      @path = path
    end

    def auto_start_provider(name, type)
      @start_provider_name = name
      @start_provider_type = type
    end

    def physical_path(path)
      @physical_path = path
    end

    def app_pool(name)
      @app_pool = name
    end

    def virtual_directory(&block)
      add_instance(@virtual_directories, IISConfig::VirtualDirectory, block)
    end

    def build_commands(site, app_pool)
      commands = []

      commands << %W{ADD APP /site.name:#{site} /path:#{@path} /physicalPath:#{@physical_path.gsub(/\//, '\\')}}

      app_pool = @app_pool unless @app_pool.nil?
      commands << %W{SET SITE /site.name:#{site}/#{@name} /[path='#{@path}'].applicationPool:#{app_pool}}

      if @start_provider_name
        commands << %W{set config -section:system.applicationHost/serviceAutoStartProviders /-"[name='#{@start_provider_name}']" /commit:apphost} if start_provider_exist? @start_provider_name
        commands << %W{set config -section:system.applicationHost/serviceAutoStartProviders /+"[name='#{@start_provider_name}',type='#{@start_provider_type}']" /commit:apphost}
        commands << %W{set app #{site}/#{@name} /serviceAutoStartEnabled:True /serviceAutoStartProvider:#{@start_provider_name}}
      end

      @virtual_directories.each do |s|
        commands += s.build_commands "#{site}/#{@name}"
      end

      commands
    end

  end

end
