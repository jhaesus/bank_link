module BankLink
  module Mac
    class Base
      attr_accessor :link, :data

      def settings *args, &block
        link.settings *args, &block
      end

      def initialize link, data
        self.link = link
        self.data = data
      end

      def generate *args
        raise NotImplementedError
      end

      def key *args
        raise NotImplementedError
      end

      def query_key *args
        raise NotImplementedError
      end

      def verify *args
        raise NotImplementedError
      end

      def keys version, type=:request
        BankLink.configuration.mac_fields[query_key][type][version.intern]
      end
    end
  end
end