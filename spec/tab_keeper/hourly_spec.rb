RSpec.describe TabKeeper::Hourly do
  subject { described_class.new(every: every, only: only, min: min).to_s }
  let(:every) { nil }
  let(:only) { nil }

  context "every hour" do
    let(:min) { 0 }
    it { is_expected.to eq("0 * * * *") }
  end

  context "every half-past" do
    let(:min) { 30 }
    it { is_expected.to eq("30 * * * *") }
  end

  context "every 3rd hour" do
    let(:min) { 0 }
    let(:every) { 3 }
    it { is_expected.to eq("0 */3 * * *") }
  end

  context "on specified hours" do
    let(:min) { 15 }
    let(:only) { [3, 9, 17] }
    it { is_expected.to eq("15 3,9,17 * * *") }
  end

  context "without the minute" do
    let(:min) { nil }
    specify { expect { subject }.to raise_error(ArgumentError) }
  end

  context "with every and only specified" do
    let(:min) { 0 }
    let(:every) { 3 }
    let(:only) { [1, 2, 3] }
    specify { expect { subject }.to raise_error(ArgumentError) }
  end

  context "with only as a single hour" do
    let(:only) { 12 }
    let(:min) { 0 }
    specify { expect { subject }.to raise_error(ArgumentError) }
  end
end
