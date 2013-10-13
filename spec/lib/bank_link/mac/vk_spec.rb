describe BankLink::Mac::VK do
  specify { expect(BankLink::Mac::VK.query_key).to eq(:VK_SERVICE) }
  specify { expect(BankLink::Mac::VK.key).to eq(:VK_MAC) }
  specify { expect(BankLink::Mac::VK.default_algorithm).to eq(OpenSSL::Digest::SHA1) }

  let(:link) do
    BankLink::Link.new(:link, :url) do |data, form|
      data.algorithm = OpenSSL::Digest::MD5
    end
  end

  let(:data) { BankLink::EStruct.new(:VK_SERVICE => "1001") }

  subject { BankLink::Mac::VK.new(link,data) }

  specify { expect(subject.key).to eq(BankLink::Mac::VK.key) }

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
    specify { expect(subject.instance_eval { request_data }).to eq("0041001000000000000000000000000000") }
  end
end