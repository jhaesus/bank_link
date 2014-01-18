describe BankLink::Configuration do
  subject { BankLink::Configuration.send(:new) }

  describe "#banks" do
    context "given name and block" do
      it "should add bank" do
        expect(subject.banks.count).to eq(0)
        subject.banks :swed do |bank|
          expect(bank).to be_a BankLink::Bank
          expect(bank.name).to eq(:swed)
        end
        expect(subject.banks.count).to eq(1)
      end
    end

    context "given name" do
      it "should return that bank" do
        subject.banks :swed do |bank|
        end
        expect(subject.banks(:swed)).to be_a BankLink::Bank
      end
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
end
