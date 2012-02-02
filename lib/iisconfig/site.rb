require 'iis_object'
require 'application'

module IISConfig

  class Site < IISObject

    def initialize
      @bindings = []
      @applications = []
      @virtual_directories = []
      @path = '/'
    end

    def name(name = nil)
      @name = name unless name.nil?
      @name
    end

    def binding(binding)
      @bindings << binding
    end

    def path(path)
      @path = path
    end

    def app_pool(pool)
      @app_pool = pool
    end

    def physical_path(path)
      @physical_path = path
    end

    def application(&block)
      add_instance(@applications, IISConfig::Application, block)
    end

    def virtual_directory(&block)
      add_instance(@virtual_directories, IISConfig::VirtualDirectory, block)
    end

    def delete
      %W{DELETE SITE #{@name}}
    end

    def add
      args = []
      args << 'ADD'
      args << 'SITE'
      args << "/name:#{@name}"
      args << "/bindings:\"#{@bindings.join('","')}\""
      args << "/physicalPath:#{@physical_path}"

      args
    end

    def build_commands()
      commands = []
      commands << delete if exist? :site, @name
      commands << add
      commands << %W{SET SITE /site.name:#{@name} /[path='#{@path}'].applicationPool:#{@app_pool}} unless @app_pool.nil?
      commands << %W{SET SITE /site.name:#{@name} /[path='#{@path}']} if @app_pool.nil?

      @applications.each do |s|
        commands += s.build_commands @name, @app_pool
      end

      @virtual_directories.each do |s|
        commands += s.build_commands "#{name}/"
      end

      commands
    end

  end

end