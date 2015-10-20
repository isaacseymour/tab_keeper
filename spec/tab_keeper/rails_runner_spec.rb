RSpec.describe TabKeeper::RailsRunner do
  subject { described_class.new(previous, job: "MyJob.run", rails_env: rails_env).to_s }

  let(:previous) { "MyJob.run" }
  let(:rails_env) { :staging }

  it { is_expected.to eq("bin/rails runner -e staging 'MyJob.run'") }

  context "when there are 's to escape" do
    let(:previous) { "MyJob.run('arg')" }
    it { is_expected.to eq("bin/rails runner -e staging 'MyJob.run('\\''arg'\\'')'") }
  end

  context "when this is the first transformer in the pipeline" do
    let(:previous) { nil }
    it { is_expected.to eq("bin/rails runner -e staging 'MyJob.run'") }
  end

  context "without a rails_env set" do
    let(:rails_env) { nil }
    it { is_expected.to eq("bin/rails runner 'MyJob.run'") }
  end
end
