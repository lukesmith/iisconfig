module IISConfig

  class SensitiveValue

    attr_reader :value

    def initialize(value)
      @value = value
    end

    def to_s
      "[SENSITIVE]"
    end

    def to_sym
      @value.to_sym
    end

  end

end