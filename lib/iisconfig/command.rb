module IISConfig

  class Command

    attr_reader :command
    attr_reader :safe_command

    def initialize(command, safe_command)
      @command = command
      @safe_command = safe_command
    end

  end

end