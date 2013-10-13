describe BankLink::Link do
  describe "#new" do
    let(:link) do
      link = BankLink::Link.new :name, "url" do |data, form|
        data.bla = 5
        form.bla = 17
      end
      link
    end
    specify { expect(link.data).to be_a BankLink::EStruct }
    specify { expect(link.form).to be_a BankLink::EStruct }
    specify { expect(link.name).to eq(:name) }
    specify { expect(link.url).to eq("url") }
    specify { expect(link.data.bla).to eq(5) }
    specify { expect(link.form.bla).to eq(17) }
  end

  describe ".processed_data" do
    let(:link) do
      BankLink::Link.new :name, "url" do |data, form|
        form.value1 = 1
        form.value2 = 2
        form.value3 = Proc.new { 3 }
        form.value4 = Proc.new { |link, object| "aaaaa" }
        data.encoding_key = "ENCODING_KEY"
        data.encoding = "UTF8"
      end
    end

    let(:data) { link.processed_data(nil) }

    before(:each) do
      allow_any_instance_of(BankLink::Mac::VK).to receive(:generate).and_return { "aaaaaaaaaaa" }
    end

    context "encoding" do
      let(:link_without_encoding) do
        BankLink::Link.new :name, "url" do |data, form|
          form.value1 = 1
          form.value2 = 2
          form.value3 = Proc.new { 3 }
          form.value4 = Proc.new { |link, object| "aaaaa" }
          data.encoding_key = :ENCODING_KEY
        end
      end
      context "should set encoding" do
        it "when given encoding key and encoding" do
          data = link.processed_data(nil)
          expect(data[:ENCODING_KEY]).to eq("UTF8")
        end
        it "unless encoding is set" do
          data = link_without_encoding.processed_data(nil)
          expect(data[:ENCODING_KEY]).to be_nil
        end
      end
    end
    it "should calculate mac" do
      expect(data[:VK_MAC]).to eq("aaaaaaaaaaa")
    end
    it "should calculate procs" do
      expect(data.value3).to eq(3)
      expect(data.value4).to eq("aaaaa")
    end
  end
end