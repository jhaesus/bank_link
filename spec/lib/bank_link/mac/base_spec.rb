describe BankLink::Mac::Base do
  it { expect { BankLink::Mac::Base.query_key }.to raise_error(NotImplementedError) }
  it { expect { BankLink::Mac::Base.key }.to raise_error(NotImplementedError) }
  it { expect { BankLink::Mac::Base.default_algorithm }.to raise_error(NotImplementedError) }

  let(:link) { BankLink::Link.new(:aaa, "aaa") }

  let(:xx) { BankLink::EStruct.new(:x => 5) }

  subject { BankLink::Mac::Base.new(link, xx) }

  describe "#new" do
    specify { expect(subject.data).to be_a(BankLink::EStruct) }
    specify { expect(subject.link).to be_a(BankLink::Link) }
  end

  describe ".generate" do
    it { expect { subject.generate }.to raise_error(NotImplementedError) }
  end

  describe ".key" do
    it { expect { subject.key }.to raise_error(NotImplementedError) }
  end
end