require "bank_link/estruct"

module BankLink
  module ViewHelpers
    def bank_link_tag link, object=nil, options={}, &block
      form_data = BankLink::EStruct.new(link.processed_data(object, options[:values] || {}))

      form_options = { :action => link.url, :method => :post }

      if encoding_key = link.data.encoding_key
        if encoding = form_data[link.data.encoding_key]
          form_options[:"accept-charset"] = encoding
        end
      end

      form_options.merge!(options[:form] || {})

      content_tag(:form, form_options) do
        form_data.each do |key, value|
          concat(hidden_field_tag(key, value, :id => nil))
        end
        concat(capture(link, &block)) if block_given?
      end
    end

    def bank_links object=nil, options={}, &block
      content_tag(:div, (options[:container] || {})) do
        BankLink.each do |link|
          concat(bank_link_tag(link, object, options, &block))
        end
      end
    end
  end
end