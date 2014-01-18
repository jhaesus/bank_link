describe BankLink::Mac::VK do

  let :bank do
    BankLink::Bank.new :name do |bank|
      bank.settings.digest = OpenSSL::Digest::MD5
    end
  end

  let :link do
    BankLink::Link.new bank, "some.url" do |form|
    end
  end

  let(:data) { Hashie::Mash.new(:VK_SERVICE => "1001") }

  subject do
    BankLink::Mac::VK.new(link, data)
  end

  specify { expect(subject.query_key).to eq(:VK_SERVICE) }
  specify { expect(subject.key).to eq(:VK_MAC) }

  let(:private_key) { double("Key") }

  let(:base64_result) {
    Base64.strict_encode64("signed_content")
  }

  describe ".generate" do
    before do
      allow(private_key).to receive(:sign) { "signed_content" }
      expect(OpenSSL::PKey::RSA).to receive(:new).and_return { private_key }
    end
    specify { expect(subject.generate).to eq(base64_result) }
  end

  describe ".request_data" do
    specify { expect(subject.instance_eval { request_data("1001") }).to eq("0041001000000000000000000000000000") }
  end
end
