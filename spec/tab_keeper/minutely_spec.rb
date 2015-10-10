RSpec.describe TabKeeper::Minutely do
  subject { described_class.new(every: every).to_s }

  context "5 minutes" do
    let(:every) { 5 }
    it { is_expected.to eq("*/5 * * * *") }
  end

  context "every minute" do
    let(:every) { nil }
    it { is_expected.to eq("* * * * *") }
  end

  context "every 30 seconds" do
    let(:every) { 0.5 }
    specify { expect { subject }.to raise_error(ArgumentError) }
  end
end
