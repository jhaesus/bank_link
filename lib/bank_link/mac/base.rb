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

      def key
        self.class.key
      end

      private
      def query_key
        self.class.query_key
      end

      def order
        BankLink.configuration.mac_fields[query_key][data[query_key].intern]
      end

      def algorithm
        link.data.algorithm || self.class.default_algorithm
      end
    end
  end
end