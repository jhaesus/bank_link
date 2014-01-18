describe BankLink::Bank do
  subject {
    BankLink::Bank.new :name do |bank|
    end
  }

  describe ".settings" do
    it "should return settings" do
      expect(subject.settings).to be_a Hashie::Mash
    end
    context "given block" do
      it "should allow to configure" do
        subject.settings do |settings|
          expect(settings).to eq(subject.settings)
        end
      end
    end
  end

  describe ".payment_link" do
    it "should return payment link" do
      subject.payment_link "some.url"
      expect(subject.payment_link).to be_a BankLink::Link
      expect(subject.payment_link.url).to eq("some.url")
    end
    context "given url" do
      it "should define new payment link" do
        expect(subject.payment_link).to be_nil
        subject.payment_link "some.url"
        expect(subject.payment_link).to be_a BankLink::Link
      end
    end
  end

  describe ".authorization_link" do
    it "should return authorization link" do
      subject.authorization_link "some.url"
      expect(subject.authorization_link).to be_a BankLink::Link
      expect(subject.authorization_link.url).to eq("some.url")
    end
    context "given url" do
      it "should define new payment link" do
        expect(subject.authorization_link).to be_nil
        subject.authorization_link "some.url"
        expect(subject.authorization_link).to be_a BankLink::Link
      end
    end
  end

end
