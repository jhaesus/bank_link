module BankLink
  module Mac
    class Base
      attr_accessor :link, :data

      def self.query_key
        raise NotImplementedError
      end

      def self.key
        raise NotImplementedError
      end

      def self.default_algorithm
        raise NotImplementedError
      end

      def initialize link, data
        self.link = link
        self.data = data
      end

      def generate
        raise NotImplementedError
      end

      def verify version, mac
        public_key = OpenSSL::X509::Certificate.new(link.data.public_key).public_key
        public_key.verify algorithm.new, Base64.strict_decode64(mac), request_data(version)
      end

      def key
        self.class.key
      end

      def query_key
        self.class.query_key
      end

      def order version
        BankLink.configuration.mac_fields[query_key][version.intern]
      end

      def algorithm
        link.data.algorithm || self.class.default_algorithm
      end
    end
  end
end