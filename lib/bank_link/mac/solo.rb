require "bank_link/mac/base"

module BankLink
  module Mac
    class Solo < BankLink::Mac::Base
      def query_key
        :SOLOPMT_VERSION
      end

      def key
        :SOLOPMT_MAC
      end

      def generate version=data[query_key]
        settings.digest.hexdigest(request_data(version).join).upcase
      end

      private
      def request_data version
        keys(version).collect { |key_name|
          field_for data[key_name].to_s
        } + [field_for(settings.private_key)]
      end

      def field_for value
        "#{value}&"
      end
    end
  end
end