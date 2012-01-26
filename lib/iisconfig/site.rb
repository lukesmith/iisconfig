require 'iis_object'

module IISConfig

  class Site < IISObject

    def initialize
      @bindings = []
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

    def delete
      %W{DELETE site #{@name}}
    end

    def add
      args = []
      args << 'ADD'
      args << 'site'
      args << "/name:#{@name}"
      args << "/bindings:\"#{@bindings.join('","')}\""
      args << "/physicalPath:#{@path}"

      args
    end

    def build_commands
      commands = []
      commands << delete if exist? :site, @name
      commands << add
      commands
    end

  end

end