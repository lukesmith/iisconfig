require 'iis_object'

module IISConfig

  class Application < IISObject

    def name(name)
      @name = name
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

    def build_commands(site, app_pool)
      commands = []

      commands << %W{ADD APP /site.name:#{site} /path:#{@path} /physicalPath:"#{@physical_path}"}

      app_pool = @app_pool unless @app_pool.nil?
      commands << %W{SET SITE /site.name:#{site}/#{@name} /[path='#{@path}'].applicationPool:#{app_pool}}

      commands
    end

  end

end