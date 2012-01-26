require 'runner'

module IISConfig

  class IISObject

    def exist?(type, name)
      args = []
      args << 'LIST'
      args << type.to_s.upcase
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

    protected

    def add_instance(collection, type, block)
      instance = type.new
      collection << instance
      block.call instance if block
    end

  end

end