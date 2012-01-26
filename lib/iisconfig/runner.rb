module IISConfig

  class Runner

    def self.execute_command(args)
      args.flatten!
      tool = :appcmd

      puts  "  #{tool.to_s} #{args.join(' ')}"
      result = `c:/windows/system32/inetsrv/appcmd #{args.join(' ')}`
      raise Exception.new($?.exitstatus) unless result
      result
    end

    def self.run_commands(commands)
      commands.each do |c|
        Runner.execute_command c
      end
    end

  end

end