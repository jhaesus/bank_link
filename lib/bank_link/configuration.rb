require "bank_link/estruct"
require "bank_link/link"
require "singleton"

module BankLink
  class Configuration
    include Singleton

    attr_accessor :links, :mac_fields, :default_encoding

    def links name=nil, url=nil, &block
      if name && url
        links[name] = Link.new(name, url, &block)
      else
        @links ||= EStruct.new
      end
    end

    def each &block
      links.marshal_dump.each_value(&block)
    end

    def mac_fields &block
      block_given? ? yield(mac_fields) : (@mac_fields ||= EStruct.new)
    end

    def initialize
      mac_fields do |ml|
        ml.VK_SERVICE = EStruct.new(
          "1001" => [
            :VK_SERVICE,
            :VK_VERSION,
            :VK_SND_ID,
            :VK_STAMP,
            :VK_AMOUNT,
            :VK_CURR,
            :VK_ACC,
            :VK_NAME,
            :VK_REF,
            :VK_MSG
          ],
          "1101" => [
            :VK_SERVICE,
            :VK_VERSION,
            :VK_SND_ID,
            :VK_REC_ID,
            :VK_STAMP,
            :VK_T_NO,
            :VK_AMOUNT,
            :VK_CURR,
            :VK_REC_ACC,
            :VK_REC_NAME,
            :VK_SND_ACC,
            :VK_SND_NAME,
            :VK_REF,
            :VK_MSG,
            :VK_T_DATE
          ],
          "1901" => [
            :VK_SERVICE,
            :VK_VERSION,
            :VK_SND_ID,
            :VK_REC_ID,
            :VK_STAMP,
            :VK_REF,
            :VK_MSG
          ]
        )
        ml.SOLOPMT_VERSION = EStruct.new(
          "0003" => [
            :SOLOPMT_VERSION,
            :SOLOPMT_STAMP,
            :SOLOPMT_RCV_ID,
            :SOLOPMT_AMOUNT,
            :SOLOPMT_REF,
            :SOLOPMT_DATE,
            :SOLOPMT_CUR
          ],
          "0002" => [
            :SOLOPMT_VERSION,
            :SOLOPMT_STAMP,
            :SOLOPMT_RCV_ID,
            :SOLOPMT_AMOUNT,
            :SOLOPMT_REF,
            :SOLOPMT_DATE,
            :SOLOPMT_CUR
          ]
        )
      end
    end
  end
end