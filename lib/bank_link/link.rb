require "bank_link/estruct"
require "bank_link/mac"

module BankLink
  class Link
    attr_accessor :name, :url, :data, :form

    def initialize name, url, &block
      self.name = name
      self.url = url
      self.data = EStruct.new(
        :mac_class => Mac::VK,
        :encoding => BankLink.configuration.default_encoding
      )
      self.form = EStruct.new
      yield(data, form) if block_given?
    end

    def processed_data object, overrides={}
      content = EStruct.new(form.marshal_dump.merge(overrides))

      content.each do |key, value|
        content[key] = content[key].call(self, object) if content[key].is_a?(Proc)
      end

      content[data.encoding_key] = data.encoding if data.encoding && data.encoding_key

      mac = data.mac_class.new(self, content)
      content[mac.key] = mac.generate
      content
    end

    def verify params
      content = EStruct.new(params)
      mac = data.mac_class.new(self, content)
      version = params[mac.query_key]
      mac.verify version, params[mac.key]
    end
  end
end