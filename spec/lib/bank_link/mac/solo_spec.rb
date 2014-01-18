describe BankLink::Mac::Solo do

  let :bank do
    BankLink::Bank.new :name do |bank|
      bank.settings.digest = OpenSSL::Digest::SHA1
      bank.settings.private_key = "SOMEKEY"
    end
  end

  let :link do
    BankLink::Link.new bank, "some.url" do |form|
    end
  end

  let(:data) { Hashie::Mash.new(:SOLOPMT_VERSION => "0003") }

  subject do
    BankLink::Mac::Solo.new(link, data)
  end

  specify { expect(subject.query_key).to eq(:SOLOPMT_VERSION) }
  specify { expect(subject.key).to eq(:SOLOPMT_MAC) }

  let(:result) { "08233F97B068D5CFF7EAD4F9C16779504E638301" }

  describe ".generate" do
    specify { expect(subject.generate).to eq(result)}
  end

  describe ".request_data" do
    specify { expect(subject.instance_eval { request_data("0003") }).to eq(["0003&", "&", "&", "&", "&", "&", "&", "SOMEKEY&"]) }
  end
end
