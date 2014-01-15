require "bank_link/link"
require "singleton"

module BankLink
  class Configuration
    include Singleton

    attr_accessor :links, :mac_fields, :default_encoding

    def links name=nil, url=nil, &block
      if name && url
        links[name] = Link.new(name, url, &block)
      else
        @links ||= Hashie::Mash.new
      end
    end

    def each &block
      links.each_value(&block)
    end

    def mac_fields &block
      block_given? ? yield(mac_fields) : (@mac_fields ||= Hashie::Mash.new)
    end

    def initialize
      file_data = YAML.load(File.read(File.dirname(__FILE__) + "/../../mac_fields.yml"))
      file_data.each do |type, versions|
        mac_fields { |mf| mf[type] = Hashie::Mash.new(versions) }
      end
    end
  end
end
