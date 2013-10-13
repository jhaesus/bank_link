describe BankLink::EStruct do
  specify { expect(subject).to be_kind_of(OpenStruct) }

  describe ".each" do
    specify { expect(subject.each).to be_a(Enumerator) }

    context "given block" do
      let(:estruct) do
        x = BankLink::EStruct.new(
          :x => 5
        )
      end

      context "with 1 parameter" do
        specify do
          estruct.each do |x|
            expect(x).to eq(5)
          end
        end
      end

      context "with 2 parameters" do
        it do
          estruct.each do |x,y|
            expect(y).to eq(5)
          end
        end

        it do
          estruct.each do |x,y|
            expect(x).to eq(:x)
          end
        end
      end
    end
  end
end