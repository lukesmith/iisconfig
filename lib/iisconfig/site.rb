module IISConfig

  class Site

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
      args << "/bindings:#{@bindings[0]}"
      args << "/physicalPath:#{@path}"

      args
    end

  end

end