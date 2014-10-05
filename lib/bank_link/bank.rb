require "bank_link/link"

module BankLink
  class Bank
    attr_accessor :name, :settings, :payment_link, :authorization_link

    def initialize name, &block
      self.name = name
      self.settings = Hashie::Mash.new(
        :mac_class => Mac::VK,
        :digest => OpenSSL::Digest::SHA1
      )
      yield(self) if block_given?
    end

    def verify params
      content = Hashie::Mash.new(params)
      mac = settings.mac_class.new(self, content)
      mac.verify content
    end

    def settings &block
      block_given? ? yield(@settings) : @settings
    end

    def payment_link url=nil, &block
      url ? (@payment_link = Link.new(self, url, &block)) : @payment_link
    end

    def authorization_link url=nil, &block
      url ? (@authorization_link = Link.new(self, url, &block)) : @authorization_link
    end
  end
end
