describe BankLink do
  it { should respond_to :each }
  describe "#configuration" do
    context "given block" do
      it "should allow access to configuration" do
        subject.configuration do |config|
          expect(config).to be_a BankLink::Configuration
        end
      end
    end
    context "without arguments" do
      it "should return configuration" do
        expect(subject.configuration).to be_a BankLink::Configuration
      end
    end
  end
end