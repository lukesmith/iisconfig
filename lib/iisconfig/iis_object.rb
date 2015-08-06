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

    def start_provider_exist?(name)
      result = Runner.execute_command %W{ LIST CONFIG /section:serviceAutoStartProviders }
      exists = false
      doc = REXML::Document.new(result)

      doc.each_element("//add[@name='#{name}']") do |e|
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
