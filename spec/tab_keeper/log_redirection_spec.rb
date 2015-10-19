RSpec.describe TabKeeper::LogRedirection do
  let(:instance) do
    described_class.new("scripts/thing",
                        job: "scripts/thing",
                        timing: timing,
                        log_directory: "/path/to/logs",
                        error_suffix: error_suffix) { |job| job_name_proc.call(job) }
  end
  subject { instance.to_s }
  let(:job_name_proc) { ->(job) { job } }
  let(:error_suffix) { nil }

  context "with minutely timing" do
    let(:timing) { TabKeeper::Minutely.new(every: 5).to_s }
    it do
      is_expected.to eq(
        "scripts/thing >> /path/to/logs/thing_" \
        "`date +\\%Y-\\%m-\\%d-\\%H-\\%m-\\%s`.log 2>&1")
    end
  end

  context "with hourly timing" do
    let(:timing) { TabKeeper::Hourly.new(every: 2).to_s }
    it do
      is_expected.to eq(
        "scripts/thing >> /path/to/logs/thing_" \
        "`date +\\%Y-\\%m-\\%d-\\%H-\\%m`.log 2>&1")
    end
  end

  context "with daily timing" do
    let(:timing) { TabKeeper::Daily.new(hour: 14).to_s }
    it do
      is_expected.to eq(
        "scripts/thing >> /path/to/logs/thing_" \
        "`date +\\%Y-\\%m-\\%d`.log 2>&1")
    end

    context "with a separate error file" do
      let(:error_suffix) { "error" }
      it do
        is_expected.to eq(
          "scripts/thing " \
          ">> /path/to/logs/thing_`date +\\%Y-\\%m-\\%d`.log " \
          "2>> /path/to/logs/thing_`date +\\%Y-\\%m-\\%d`.error.log")
      end
    end

    context "with a fun job name proc" do
      let(:job_name_proc) { -> (job) { "#{job}_sadness" } }
      it do
        is_expected.to eq(
          "scripts/thing >> /path/to/logs/thing_sadness_" \
          "`date +\\%Y-\\%m-\\%d`.log 2>&1")
      end
    end
  end

  context "with weekly timing" do
    let(:timing) { TabKeeper::Weekly.new(hour: 14, day: :tuesday).to_s }
    it do
      is_expected.to eq(
        "scripts/thing >> /path/to/logs/thing_" \
        "`date +\\%Y-\\%m-\\%d`.log 2>&1")
    end
  end

  context "with monthly timing" do
    let(:timing) { TabKeeper::Monthly.new(day: 5, hour: 12).to_s }
    it do
      is_expected.to eq(
        "scripts/thing >> /path/to/logs/thing_" \
        "`date +\\%Y-\\%m`.log 2>&1")
    end
  end
end
