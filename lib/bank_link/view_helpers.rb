module BankLink
  module ViewHelpers
    def bank_link_tag link, object=nil, options={}, &block
      form_data = Hashie::Mash.new(link.processed_data(object, options[:values] || {}))
      form_options = bank_link_form_options link, form_data, options

      content_tag(:form, form_options) do
        form_data.each do |key, value|
          concat(hidden_field_tag(key, value, :id => nil))
        end
        concat(capture(link, &block)) if block_given?
      end
    end

    def authorization_links object=nil, options={}, &block
      bank_links :authorization_links, object, options, &block
    end

    def payment_links object=nil, options={}, &block
      bank_links :payment_links, object, options, &block
    end

    private

    def bank_links type, object, options, &block
      content_tag(:div, (options[:container] || {})) do
        BankLink.method(type).call do |link|
          concat(bank_link_tag(link, object, options, &block))
        end
      end
    end

    def bank_link_form_options link, form_data, options={}
      form_options = { :action => link.url, :method => :post }

      if encoding_key = link.settings.encoding_key
        if encoding = form_data[link.settings.encoding_key]
          form_options[:"accept-charset"] = encoding
        end
      end

      form_options.merge!(options[:form] || {})

      form_options
    end
  end
end
