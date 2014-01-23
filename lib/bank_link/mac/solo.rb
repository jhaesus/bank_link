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

      def verify content
        version = content[returnify(query_key)]
        check = content[returnify(key)]
        settings.digest.hexdigest(request_data(version, :response).join).upcase == check
      end

      def returnify key
        key.to_s.gsub('SOLOPMT_','SOLOPMT_RETURN_')
      end

      private
      def request_data version, type=:request
        keys(version, type).collect { |key_name|
          field_for data[key_name].to_s
        } + [field_for(settings.private_key)]
      end

      def field_for value
        "#{value}&"
      end
    end
  end
end