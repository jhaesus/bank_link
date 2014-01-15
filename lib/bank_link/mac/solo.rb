require "bank_link/mac/base"
require "openssl"

module BankLink
  module Mac
    class Solo < BankLink::Mac::Base
      def self.query_key
        :SOLOPMT_VERSION
      end

      def self.key
        :SOLOPMT_MAC
      end

      def self.default_algorithm
        OpenSSL::Digest::MD5
      end

      def generate version=data[query_key]
        algorithm.hexdigest(request_data(version).join).upcase
      end

      private
      def request_data version
        order(version).collect { |key_name|
          field_for data[key_name].to_s
        } + [field_for(link.data.mac_key)]
      end

      def field_for value
        "#{value}&"
      end
    end
  end
end