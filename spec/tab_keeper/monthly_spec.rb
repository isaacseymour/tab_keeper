RSpec.describe TabKeeper::Monthly do
  subject { described_class.new(day: day, hour: hour, min: min).to_s }
  let(:day) { 1 }
  let(:hour) { 13 }
  let(:min) { 0 }

  context "on the first of the month" do
    let(:day) { 1 }
    it { is_expected.to eq("0 13 1 * *") }
  end

  context "on the 15th of the month" do
    let(:day) { 15 }
    it { is_expected.to eq("0 13 15 * *") }
  end

  context "without the minute" do
    let(:min) { nil }
    specify { expect { subject }.to raise_error(ArgumentError) }
  end

  context "without the hour" do
    let(:hour) { nil }
    specify { expect { subject }.to raise_error(ArgumentError) }
  end

  context "without the day" do
    let(:day) { nil }
    specify { expect { subject }.to raise_error(ArgumentError) }
  end

  context "with a weird minute" do
    let(:min) { 60 }
    specify { expect { subject }.to raise_error(ArgumentError) }
  end

  context "with a weird hour" do
    let(:hour) { -1 }
    specify { expect { subject }.to raise_error(ArgumentError) }
  end

  context "with a weird day" do
    let(:day) { 29 }
    specify { expect { subject }.to raise_error(ArgumentError) }
  end

  context "with a symbol day" do
    let(:day) { :thursday }
    specify { expect { subject }.to raise_error(ArgumentError) }
  end
end
