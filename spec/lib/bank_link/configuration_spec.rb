describe BankLink::Configuration do
  subject { BankLink::Configuration.send(:new) }
  before do
    subject.links(:aaa, "url") do |data, form|
      data.bla = 5
      form.something = 17
    end
  end
  let(:test_link) do
    subject.links[:aaa]
  end

  describe "#links" do
    context "given arguments" do
      it "should add link" do
        expect(subject.links.count).to eq(1)
        subject.links(:bbb, "url")
        expect(subject.links.count).to eq(2)
      end
    end
    context "given block" do
      it "should insert new link" do
        expect(subject.links.count).to eq(1)
        subject.links(:ccc, "url") do |data, form|
          data.in_block = true
          form.x = "false"
        end
        expect(subject.links.count).to eq(2)
        ccc = subject.links[:ccc]
        expect(ccc.name).to eq(:ccc)
        expect(ccc.url).to eq("url")
        expect(ccc.data.in_block).to be_true
        expect(ccc.form.x).to eq("false")
      end
    end

    context "without arguments" do
      specify { expect(subject.links).to be_a Hashie::Mash }
    end
  end

  describe "#mac_fields" do
    context "given block" do
      specify do
        subject.mac_fields do |mf|
          expect(mf).to be_a Hashie::Mash
        end
      end
    end

    context "without arguments" do
      specify { expect(subject.mac_fields).to be_a Hashie::Mash }
    end
  end

  describe "#each" do
    context "given block" do
      specify do
        subject.each do |link|
          expect(link).to be_a BankLink::Link
        end
      end
    end

    context "without arguments" do
      specify { expect(subject.each).to be_a Enumerator }
    end
  end

  describe "#default_encoding" do
    specify { expect(subject.default_encoding).to be_nil }
  end

  describe "#default_encoding=" do
    it "should set default_encoding" do
      subject.default_encoding = "bla"
      expect(subject.default_encoding).to_not be_nil
    end
  end
end
