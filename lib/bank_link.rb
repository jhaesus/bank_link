require "bank_link/version"
require "bank_link/configuration"
require "bank_link/mac"

require "hashie"

begin
  require "rails/all"
rescue LoadError
else
  require "bank_link/railtie" if defined?(Rails)
end

module BankLink
  class << self
    def configuration
      block_given? ? yield(configuration) : (@configuration ||= Configuration.instance)
    end

    def payment_links *args, &block
      configuration.payment_links(*args, &block)
    end

    def authorization_links *args, &block
      configuration.authorization_links(*args, &block)
    end
  end
end

def BankLink &block
  ::BankLink.configuration(&block)
end