require 'iis_object'
require 'application'

module IISConfig

  class FtpSite < IISObject

    def initialize
      @bindings = []
      @authentication = []
      @allow_authorization = []
    end

    def name(name = nil)
      @name = name unless name.nil?
      @name
    end

    def binding(binding)
      @bindings << binding
    end

    def app_pool(pool)
      @app_pool = pool
    end

    def physical_path(path)
      @physical_path = path
    end

    def enable_authentication(*authentication)
      @authentication += authentication
    end

    def allow_authorization(permissions, access)
      @allow_authorization << { :permissions => permissions, :access => access }
    end

    def allow_ssl
      @ssl = :allow
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
      args << "/physicalPath:\"#{@physical_path.gsub(/\//, '\\')}\""

      args
    end

    def required_paths
      paths = []
      paths << @physical_path
      paths
    end

    def build_commands()
      commands = []
      commands << delete if exist? :site, @name
      commands << add

      commands << %W{SET SITE /site.name:#{@name} /[path='/'].applicationPool:#{@app_pool}} unless @app_pool.nil?

      @allow_authorization.each do |a|
        permissions = a[:permissions].map { |p| p.capitalize }.join(',')
        roles = a[:access][:roles]
        users = a[:access][:users]
        commands << %W{SET CONFIG #{@name} /section:system.ftpserver/security/authorization /+[accessType='Allow',permissions='#{permissions}',roles='#{roles}',users='#{users}'] /commit:apphost}
      end

      @authentication.each do |a|
        commands << %W{SET CONFIG -section:system.applicationHost/sites /[name='#{@name}'].ftpServer.security.authentication.#{a}Authentication.enabled:true}
      end

      unless @ssl.nil?
        commands << %W{SET CONFIG -section:system.applicationHost/sites /[name='#{@name}'].ftpServer.security.ssl.controlChannelPolicy:"Ssl#{@ssl.capitalize}"}
        commands << %W{SET CONFIG -section:system.applicationHost/sites /[name='#{@name}'].ftpServer.security.ssl.dataChannelPolicy:"Ssl#{@ssl.capitalize}"}
      end

      commands
    end

  end

end