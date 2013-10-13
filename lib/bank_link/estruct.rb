require "ostruct"
module BankLink
  class EStruct < OpenStruct
    def each &block
      if block_given? && block.arity == 1
        @table.each_value(&block)
      else
        @table.each(&block)
      end
    end

    def count
      marshal_dump.count
    end

    if RUBY_VERSION < "2.0.0"
      def [](name)
        @table[name.to_sym]
      end

      def []=(name, value)
        modifiable[new_ostruct_member(name)] = value
      end
    end
  end
end