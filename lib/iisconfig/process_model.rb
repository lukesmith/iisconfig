module IISConfig

  # Configuration of the Process Model Settings for an Application Pool
  # Reference: http://www.iis.net/configreference/system.applicationhost/applicationpools/add/processmodel
  #
  class ProcessModel

    def initialize
      @settings = {}
    end

    def identity_type(type = nil)
      setting(:identityType, type)
    end

    # Specifies how long a worker process should run idle.
    def idle_timeout(timeout = nil)
      setting(:idleTimeout, timeout)
    end

    def load_user_profile(value = nil)
      setting(:loadUserProfile, value)
    end

    def logon_type(value = nil)
      setting(:logonType, value)
    end

    def manual_group_membership(value = nil)
      setting(:manualGroupMembership, value)
    end

    def max_processes(value = nil)
      setting(:maxProcesses, value)
    end

    def password(value = nil)
      setting(:password, value)
    end

    def pinging_enabled(value = nil)
      setting(:pingingEnabled, value)
    end

    def ping_interval(value = nil)
      setting(:pingInterval, value)
    end

    def ping_response_time(value = nil)
      setting(:pingResponseTime, value)
    end

    def shutdown_time_limit(value = nil)
      setting(:shutdownTimeLimit, value)
    end

    def startup_time_limit(value = nil)
      setting(:startupTimeLimit, value)
    end

    def username(value = nil)
      setting(:userName, value)
    end

    def settings
      @settings
    end

    private

    def setting(key, value)
      @settings[key] = value unless value.nil?
      @settings[key]
    end

  end

end