require "bank_link/bank"
require "singleton"

module BankLink
  class Configuration
    include Singleton

    attr_accessor :banks, :mac_fields, :default_encoding

    def banks name=nil, &block
      if name && block_given?
        @banks[name] = Bank.new(name, &block)
      elsif name
        @banks[name]
      else
        @banks
      end
    end

    def authorization_links &block
      each_link :authorization_link, &block
    end

    def payment_links &block
      each_link :payment_link, &block
    end

    def mac_fields &block
      block_given? ? yield(mac_fields) : (@mac_fields ||= Hashie::Mash.new)
    end

    def initialize
      file_data = YAML.load(File.read(File.dirname(__FILE__) + "/../../mac_fields.yml"))
      file_data.each do |type, versions|
        mac_fields { |mf| mf[type] = Hashie::Mash.new(versions) }
      end
      @banks ||= Hashie::Mash.new
    end

    def each_link type, &block
      banks.collect { |name, bank| bank.method(type).call() }.compact.each(&block)
    end
  end
end
