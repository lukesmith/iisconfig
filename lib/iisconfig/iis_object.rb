require 'runner'

module IISConfig

  class IISObject

    def exist?(type, name)
      args = []
      args << 'LIST'
      args << type.to_s
      args << '/xml'
      result = Runner.execute_command args

      exists = false
      doc = REXML::Document.new(result)

      doc.elements.each("appcmd/#{type.to_s.upcase}[@#{type.to_s.upcase}.NAME='#{name}']") do
        exists = true
        break
      end

      exists
    end

  end

end