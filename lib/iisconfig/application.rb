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

      commands << %W{ADD APP /site.name:#{site} /path:#{@path} /physicalPath:"#{@physical_path}"}

      app_pool = @app_pool unless @app_pool.nil?
      commands << %W{SET SITE /site.name:#{site}/#{@name} /[path='#{@path}'].applicationPool:#{app_pool}}

      @virtual_directories.each do |s|
        commands += s.build_commands "#{site}/#{@name}"
      end

      commands
    end

  end

end