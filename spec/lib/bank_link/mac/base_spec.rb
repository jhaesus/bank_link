describe BankLink::Mac::Base do
  let :bank do
    BankLink::Bank.new :name do |bank|
    end
  end

  let :link do
    BankLink::Link.new bank, "some.url" do |form|
    end
  end

  subject do
    BankLink::Mac::Base.new(link, Hashie::Mash.new)
  end

  it { expect { subject.key }.to raise_error(NotImplementedError) }
  it { expect { subject.query_key }.to raise_error(NotImplementedError) }
  it { expect { subject.generate }.to raise_error(NotImplementedError) }
  it { expect { subject.verify }.to raise_error(NotImplementedError) }
  it { expect { subject.keys("111") }.to raise_error(NotImplementedError) }
end
