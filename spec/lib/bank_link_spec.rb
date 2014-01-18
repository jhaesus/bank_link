describe BankLink do
  describe "#configuration" do
    context "given block" do
      it "should allow to configure" do
        subject.configuration do |config|
          expect(config).to eq subject.configuration
        end
      end
    end
    context "without arguments" do
      it "should return configuration" do
        expect(subject.configuration).to be_a BankLink::Configuration
      end
    end
  end

  describe "#payment_links" do
    it "should delegate to configuration" do
      expect(BankLink.configuration).to receive(:payment_links)
      subject.payment_links
    end
  end

  describe "#authorization_links" do
    it "should delegate to configuration" do
      expect(BankLink.configuration).to receive(:authorization_links)
      subject.authorization_links
    end
  end
end