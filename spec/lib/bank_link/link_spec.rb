describe BankLink::Link do
  let :bank do
    BankLink::Bank.new :name do |bank|
    end
  end

  let :bank2 do
    BankLink::Bank.new :name do |bank|
    end
  end

  subject {
    BankLink::Link.new bank, "some.url" do |form|
    end
  }

  describe ".settings" do
    it "should delegate to bank" do
      expect(subject.bank).to receive(:settings)
      subject.settings
    end
  end

  describe ".processed_data" do

    before(:each) do
      subject.form.value1 = 1
      subject.form.value2 = 2
      subject.form.value3 = Proc.new { 3 }
      subject.form.value4 = Proc.new { |link, object| "aaaaa" }
      bank.settings.encoding_key = "ENCODING_KEY"
      bank.settings.encoding = "UTF8"

      allow_any_instance_of(BankLink::Mac::VK).to receive(:generate).and_return { "aaaaaaaaaaa" }
    end

    let(:data) { subject.processed_data(nil) }

    let(:link_without_encoding) do
      BankLink::Link.new bank2, "url" do |form|
        form.value1 = 1
        form.value2 = 2
        form.value3 = Proc.new { 3 }
        form.value4 = Proc.new { |link, object| "aaaaa" }
      end
    end

    context "encoding" do
      context "should set encoding" do
        it "when given encoding key and encoding" do
          data = subject.processed_data(nil)
          expect(data[:ENCODING_KEY]).to eq("UTF8")
        end
        it "unless encoding is set" do
          data = link_without_encoding.processed_data(nil)
          expect(data[:ENCODING_KEY]).to be_nil
        end
      end
    end
    it "should calculate mac" do
      data = link_without_encoding.processed_data(nil)
      expect(data[:VK_MAC]).to eq("aaaaaaaaaaa")
    end
    it "should calculate procs" do
      expect(data.value3).to eq(3)
      expect(data.value4).to eq("aaaaa")
    end
  end
end
