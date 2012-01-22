module IISConfig

  class AppPool

    def initialize
      @pipeline_mode = :Classic
      @runtime_version = :'v2.0'
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

    def delete
      args = []
      args << 'DELETE'
      args << 'apppool'
      args << "#{@name}"
      args
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

  end
  
end