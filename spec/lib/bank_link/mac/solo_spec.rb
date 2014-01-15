describe BankLink::Mac::Solo do
  specify { expect(BankLink::Mac::Solo.query_key).to eq(:SOLOPMT_VERSION) }
  specify { expect(BankLink::Mac::Solo.key).to eq(:SOLOPMT_MAC) }
  specify { expect(BankLink::Mac::Solo.default_algorithm).to eq(OpenSSL::Digest::MD5) }

  let(:link_sha1) do
    BankLink::Link.new(:link, :url) do |data, form|
      data.algorithm = OpenSSL::Digest::SHA1
      data.mac_key = "SOMEKEY"
    end
  end

  let(:link_md5) do
    BankLink::Link.new(:link, :url) do |data, form|
      data.mac_key = "SOMEKEY"
    end
  end

  let(:data) { Hashie::Mash.new(:SOLOPMT_VERSION => "0003") }

  let(:mac_sha1) { BankLink::Mac::Solo.new(link_sha1,data) }
  let(:mac_md5) { BankLink::Mac::Solo.new(link_md5,data) }


  specify { expect(mac_sha1.key).to eq(BankLink::Mac::Solo.key) }
  specify { expect(mac_md5.key).to eq(BankLink::Mac::Solo.key) }

  let(:sha1_result) { "08233F97B068D5CFF7EAD4F9C16779504E638301" }
  let(:md5_result) { "7990ACDD585F151ED8C9405B5838EEDC" }

  describe ".generate" do
    context "algorithm is sha1" do
      specify { expect(mac_sha1.generate).to eq(sha1_result)}
    end
    context "algirithm is md5" do
      specify { expect(mac_md5.generate).to eq(md5_result)}
    end
  end

  describe ".request_data" do
    specify { expect(mac_sha1.instance_eval { request_data("0003") }).to eq(["0003&", "&", "&", "&", "&", "&", "&", "SOMEKEY&"]) }
    specify { expect(mac_md5.instance_eval { request_data("0003") }).to eq(["0003&", "&", "&", "&", "&", "&", "&", "SOMEKEY&"]) }
  end
end
