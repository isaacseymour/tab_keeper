RSpec.describe TabKeeper::JobList do
  subject(:instance) { described_class.new }

  it "yields itself" do
    yielded = nil
    returned = described_class.new { |tab| yielded = tab }
    expect(yielded).to be(returned)
  end

  describe "#add" do
    pending "rejects invalid timers" do
      expect { instance.add("thing", "* *-2 50 * -1") }.to raise_error(ArgumentError)
    end
  end

  describe "#daily" do
    it "passes options through to Daily.new" do
      expect(TabKeeper::Daily).to receive(:new).with(hour: 5).and_call_original
      instance.daily("thing", hour: 5)
    end
  end

  describe "#hourly" do
    it "passes options through to Hourly.new" do
      expect(TabKeeper::Hourly).to receive(:new).with(min: 5).and_call_original
      instance.hourly("thing", min: 5)
    end
  end

  describe "#minutely" do
    it "passes options through to Minutely.new" do
      expect(TabKeeper::Minutely).to receive(:new).and_call_original
      instance.minutely("thing")
    end
  end

  describe "#monthly" do
    it "passes options through to Monthly.new" do
      expect(TabKeeper::Monthly).to receive(:new).with(day: 14, hour: 5).and_call_original
      instance.monthly("thing", day: 14, hour: 5)
    end
  end

  describe "#weekly" do
    it "passes options through to Weekly.new" do
      expect(TabKeeper::Weekly).to receive(:new).with(day: :monday, hour: 5).
        and_call_original
      instance.weekly("thing", day: :monday, hour: 5)
    end
  end
end
