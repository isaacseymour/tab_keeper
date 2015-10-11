RSpec.describe TabKeeper::LoginShell do
  subject { described_class.new(previous, job: job, code_directory: code_directory).to_s }
  let(:job) { "bin/some_script" }
  let(:code_directory) { "/path/to/code" }
  let(:previous) { nil }

  it { is_expected.to eq("/bin/bash -l -c 'cd /path/to/code && bin/some_script'") }

  context "with a previous command" do
    let(:previous) { "SOMEVAR=value bin/some_script" }
    it do
      is_expected.
        to eq("/bin/bash -l -c 'cd /path/to/code && SOMEVAR=value bin/some_script'")
    end
  end

  context "when the job needs escaping" do
    let(:job) { "bin/run 'MyJob.run(\\'arg\\')'" }
    it do
      is_expected.to eq(
        "/bin/bash -l -c 'cd /path/to/code && bin/run \\'MyJob.run(\\\\'arg\\\\')\\''")
    end
  end
end
