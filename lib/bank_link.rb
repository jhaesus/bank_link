require "bank_link/version"
require "bank_link/configuration"
begin
  require "rails/all"
rescue LoadError
else
  require "bank_link/railtie" if defined?(Rails)
end

module BankLink
  class << self
    def configuration
      block_given? ? yield(configuration) : (@configuration ||= BankLink::Configuration.instance)
    end

    def each &block
      configuration.each(&block)
    end
  end
end
