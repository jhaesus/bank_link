require "bank_link/mac/base"
require "openssl"
require "base64"


module BankLink
  module Mac
    class VK < BankLink::Mac::Base
      def query_key
        :VK_SERVICE
      end

      def key
        :VK_MAC
      end

      def generate version=data[query_key]
        Base64.strict_encode64(
          private_key.sign(settings.digest.new, request_data(version))
        )
      end

      def verify version, mac
        public_key = OpenSSL::X509::Certificate.new(settings.public_key).public_key
        public_key.verify settings.digest.new, Base64.strict_decode64(mac), request_data(version)
      end

      private

      def private_key
        OpenSSL::PKey::RSA.new(settings.private_key, settings.private_key_passphrase)
      end

      def field_for value
        ["%03d" % value.length, value]
      end

      def request_data version
        keys(version).collect { |key_name|
          field_for data[key_name].to_s
        }.flatten.join
      end
    end
  end
end