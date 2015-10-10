RSpec.describe TabKeeper::Daily do
  subject { described_class.new(hour: hour, min: min).to_s }

  context "midnight" do
    let(:hour) { 0 }
    let(:min) { 0 }
    it { is_expected.to eq("0 0 * * *") }
  end

  context "7:30am" do
    let(:hour) { 7 }
    let(:min) { 30 }
    it { is_expected.to eq("30 7 * * *") }
  end

  context "without min supplied" do
    let(:hour) { 12 }
    let(:min) { nil }
    specify { expect { subject }.to raise_error(ArgumentError) }
  end

  context "without hour supplied" do
    let(:hour) { nil }
    let(:min) { 2 }
    specify { expect { subject }.to raise_error(ArgumentError) }
  end

  context "with a weird hour" do
    let(:hour) { 24 }
    let(:min) { 0 }
    specify { expect { subject }.to raise_error(ArgumentError) }
  end

  context "with a weird minute" do
    let(:hour) { 12 }
    let(:min) { -1 }
    specify { expect { subject }.to raise_error(ArgumentError) }
  end
end
