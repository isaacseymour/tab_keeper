RSpec.describe TabKeeper::Weekly do
  subject { described_class.new(day: day, hour: hour, min: min).to_s }
  let(:day) { :wednesday }
  let(:hour) { 13 }
  let(:min) { 0 }

  context "every Thursday" do
    let(:day) { :thursday }
    it { is_expected.to eq("0 13 * * 4") }
  end

  context "every 3rd day of the week" do
    let(:day) { 3 }
    it { is_expected.to eq("0 13 * * 3") }
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
    let(:day) { 8 }
    specify { expect { subject }.to raise_error(ArgumentError) }
  end

  context "with a string day" do
    let(:day) { "thursday" }
    specify { expect { subject }.to raise_error(ArgumentError) }
  end
end
