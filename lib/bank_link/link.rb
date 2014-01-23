module BankLink
  class Link
    attr_accessor :bank, :url, :form

    def initialize bank, url, &block
      self.bank = bank
      self.url = url
      self.form = Hashie::Mash.new
      yield(form) if block_given?
    end

    def settings *args, &block
      bank.settings *args, &block
    end

    def processed_data object, overrides={}
      content = Hashie::Mash.new(form.merge(overrides))
      apply_encoding content
      calculate_keys content, object
      calculate_mac content
      content
    end

    def verify params
      content = Hashie::Mash.new(params)
      mac = settings.mac_class.new(self, content)
      mac.verify content
    end

    def calculate_keys content, object
      content.each do |key, value|
        content[key] = content[key].call(self, object) if content[key].is_a?(Proc)
      end
    end

    def apply_encoding content
      content[settings.encoding_key] = settings.encoding if settings.encoding && settings.encoding_key
    end

    def calculate_mac content
      mac = settings.mac_class.new(self, content)
      content[mac.key] = mac.generate
    end

  end
end
