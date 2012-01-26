module IISConfig

  class ProcessModel

    def identity_type(type = nil)
      @identity_type = type unless type.nil?
      @identity_type
    end

    def settings
      settings = []
      settings << { key: 'identityType', value: @identity_type } unless @identity_type.nil?
      settings
    end

  end

end