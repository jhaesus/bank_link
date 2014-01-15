require "bank_link/mac/base"
require "openssl"
require "base64"


module BankLink
  module Mac
    class VK < BankLink::Mac::Base
      def self.query_key
        :VK_SERVICE
      end

      def self.key
        :VK_MAC
      end

      def self.default_algorithm
        OpenSSL::Digest::SHA1
      end

      def generate version=data[query_key]
        Base64.strict_encode64(
          algorithm_key.sign(algorithm.new, request_data(version))
        )
      end

      private
      def algorithm_key
        OpenSSL::PKey::RSA.new(link.data.mac_key, link.data.mac_key_passphrase)
      end

      def field_for value
        ["%03d" % value.length, value]
      end

      def request_data version
        order(version).collect { |key_name|
          field_for data[key_name].to_s
        }.flatten.join
      end
    end
  end
end