class BLVHDummy
  include ::ActionView::Helpers::UrlHelper
  include ::ActionView::Helpers::TagHelper
  include ::ActionView::Helpers::CaptureHelper
  include ::ActionView::Helpers::FormTagHelper
  include ::ActionView::Context
  include ::BankLink::ViewHelpers
end

describe BankLink::ViewHelpers do

  subject { BLVHDummy.new }
  before(:all) do
    BankLink.configuration do |config|
      config.banks :dummy_bank do |bank|
        bank.settings.mac_class = BankLink::Mac::Solo
        bank.settings.private_key = "MY MAC KEY"
        bank.settings.digest = OpenSSL::Digest::MD5

        bank.payment_link "https://some.where.com" do |form|
          form[:SOLOPMT_VERSION] = "0003"
          form[:SOLOPMT_STAMP] = "555"
          form[:SOLOPMT_RCV_ID] = "99999999"
          form[:SOLOPMT_AMOUNT] = "55.12"
          form[:SOLOPMT_REF] = "55"
          form[:SOLOPMT_MSG] = Proc.new { |link, object| "message for payment" }
          form[:SOLOPMT_RETURN] = Proc.new { |link, object| "http://some.where.else1.com" }
          form[:SOLOPMT_CANCEL] = Proc.new { |link, object| "http://some.where.else2.com" }
          form[:SOLOPMT_REJECT] = Proc.new { |link, object| "http://some.where.else3.com" }
          form[:SOLOPMT_CONFIRM] = "YES"
          form[:SOLOPMT_KEYVERS] = "0001"
          form[:SOLOPMT_DATE] = "EXPRESS"
          form[:SOLOPMT_CUR] = "EUR"
          form[:SOLOPMT_LANGUAGE] = "3"
        end
      end

      config.banks :dummy_bank_w_encoding do |bank|
        bank.settings.mac_class = BankLink::Mac::Solo
        bank.settings.private_key = "MY MAC KEY"
        bank.settings.encoding_key = "VK_ENCODING"
        bank.settings.encoding = "UTF-8"
        bank.settings.digest = OpenSSL::Digest::MD5

        bank.payment_link "https://some.where.com" do |form|
          form[:SOLOPMT_VERSION] = "0003"
          form[:SOLOPMT_STAMP] = "555"
          form[:SOLOPMT_RCV_ID] = "99999999"
          form[:SOLOPMT_AMOUNT] = "55.12"
          form[:SOLOPMT_REF] = "55"
          form[:SOLOPMT_MSG] = Proc.new { |link, object| "message for payment" }
          form[:SOLOPMT_RETURN] = Proc.new { |link, object| "http://some.where.else1.com" }
          form[:SOLOPMT_CANCEL] = Proc.new { |link, object| "http://some.where.else2.com" }
          form[:SOLOPMT_REJECT] = Proc.new { |link, object| "http://some.where.else3.com" }
          form[:SOLOPMT_CONFIRM] = "YES"
          form[:SOLOPMT_KEYVERS] = "0001"
          form[:SOLOPMT_DATE] = "EXPRESS"
          form[:SOLOPMT_CUR] = "EUR"
          form[:SOLOPMT_LANGUAGE] = "3"
        end
      end
    end
  end

  let(:dummy_link) { BankLink.configuration.banks[:dummy_bank].payment_link }

  let(:dummy_link_w_encoding) { BankLink.configuration.banks[:dummy_bank_w_encoding].payment_link }

  let(:result_plain) { subject.bank_link_tag(dummy_link) }

  let(:result_encoding) { subject.bank_link_tag(dummy_link_w_encoding) }

  let(:result_block) {
    subject.bank_link_tag(dummy_link_w_encoding) do
      "aaaaaaaaaaaaaaaaaaaaaaa"
    end
  }

  describe ".bank_link_tag" do
    before(:all) do
      @proc = Proc.new { |result|
        expect(result).to start_with("<form ")
        expect(result).to include("action=\"https://some.where.com\"")
        expect(result).to include("method=\"post\"")
        expect(result).to include("<input name=\"SOLOPMT_VERSION\" type=\"hidden\" value=\"0003\" />")
        expect(result).to include("<input name=\"SOLOPMT_STAMP\" type=\"hidden\" value=\"555\" />")
        expect(result).to include("<input name=\"SOLOPMT_RCV_ID\" type=\"hidden\" value=\"99999999\" />")
        expect(result).to include("<input name=\"SOLOPMT_AMOUNT\" type=\"hidden\" value=\"55.12\" />")
        expect(result).to include("<input name=\"SOLOPMT_REF\" type=\"hidden\" value=\"55\" />")
        expect(result).to include("<input name=\"SOLOPMT_MSG\" type=\"hidden\" value=\"message for payment\" />")
        expect(result).to include("<input name=\"SOLOPMT_RETURN\" type=\"hidden\" value=\"http://some.where.else1.com\" />")
        expect(result).to include("<input name=\"SOLOPMT_CANCEL\" type=\"hidden\" value=\"http://some.where.else2.com\" />")
        expect(result).to include("<input name=\"SOLOPMT_REJECT\" type=\"hidden\" value=\"http://some.where.else3.com\" />")
        expect(result).to include("<input name=\"SOLOPMT_CONFIRM\" type=\"hidden\" value=\"YES\" />")
        expect(result).to include("<input name=\"SOLOPMT_KEYVERS\" type=\"hidden\" value=\"0001\" />")
        expect(result).to include("<input name=\"SOLOPMT_DATE\" type=\"hidden\" value=\"EXPRESS\" />")
        expect(result).to include("<input name=\"SOLOPMT_CUR\" type=\"hidden\" value=\"EUR\" />")
        expect(result).to include("<input name=\"SOLOPMT_LANGUAGE\" type=\"hidden\" value=\"3\" />")
        expect(result).to include("<input name=\"SOLOPMT_MAC\" type=\"hidden\" value=\"C4E032FC50F78B6D5DED36F283A1193B\" />")
        expect(result).to end_with("</form>")
      }
    end

    context "regular data" do
      it do
        [result_plain, result_encoding, result_block].each do |result|
          @proc.call(result)
        end
      end
    end

    context "without encoding" do
      specify { expect(result_plain).not_to include("accept-charset") }
    end

    context "with encoding" do
      specify { expect(result_encoding).to include("accept-charset=\"UTF-8\"") }
      specify { expect(result_encoding).to include("<input name=\"VK_ENCODING\" type=\"hidden\" value=\"UTF-8\" />") }
    end

    context "with block" do
      specify { expect(result_block).to include("aaaaaaaaaaaaaaaaaaaaaaa") }
    end
  end
end