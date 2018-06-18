module IISConfig

  class Runner

    def self.execute_command(args)
      args = [args].flatten
      tool = :appcmd

      safe_command = args.map { |v| v.is_a?(IISConfig::Command) ? v.safe_command : v }
      command = args.map { |v| v.is_a?(IISConfig::Command) ? v.command : v }

      puts  "  #{tool.to_s} #{safe_command.join(' ')}"

      unless IISConfiguration.dry_run?
        result = `c:/windows/system32/inetsrv/appcmd #{command.join(' ')}"`
        puts result if IISConfiguration.verbose?
        raise Exception.new($?.exitstatus) unless $?.success?
        result
      end
    end

    def self.run_commands(commands)
      commands.each do |c|
        Runner.execute_command c
      end
    end

  end

end
