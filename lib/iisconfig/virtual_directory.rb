require 'iis_object'

module IISConfig

  class VirtualDirectory < IISObject

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

    def build_commands(application)
      commands = []

      commands << %W{ADD VDIR /app.name:#{application} /path:#{@path} /physicalPath:#{@physical_path.gsub(/\//, '\\')}}

      commands
    end

  end

end