RSpec.describe TabKeeper::Generator do
  subject { described_class.new(*pipeline).generate(job_list, **options) }
  let(:job_list) do
    TabKeeper::JobList.new do |tab|
      tab.minutely("FrequentJob.run", every: 5)
      tab.daily("MidnightJob.run", hour: 0)
      tab.daily("LunchtimeJob.run", hour: 12, min: 30)
      tab.weekly("HappyMondayJob.run", day: :monday, hour: 7, min: 30)
      tab.monthly("PaydayJob.run", day: 25, hour: 16, min: 15)
    end.to_a
  end

  let(:pipeline) do
    [TabKeeper::RailsRunner, TabKeeper::LogRedirection, TabKeeper::LoginShell]
  end
  let(:options) do
    {
      code_directory: '/path/to/code',
      rails_env: :production,
      log_directory: '/path/to/logs',
      include_date_in_log_name: true
    }
  end

  it do
    is_expected.to eq <<-CRONTAB
*/5 * * * * /bin/bash -l -c 'cd /path/to/code && bin/rails runner -e production '\\''FrequentJob.run'\\'' >> /path/to/logs/FrequentJob_`date +\\%Y-\\%m-\\%d-\\%H-\\%M-\\%s`.log 2>&1'

0 0 * * * /bin/bash -l -c 'cd /path/to/code && bin/rails runner -e production '\\''MidnightJob.run'\\'' >> /path/to/logs/MidnightJob_`date +\\%Y-\\%m-\\%d`.log 2>&1'

30 12 * * * /bin/bash -l -c 'cd /path/to/code && bin/rails runner -e production '\\''LunchtimeJob.run'\\'' >> /path/to/logs/LunchtimeJob_`date +\\%Y-\\%m-\\%d`.log 2>&1'

30 7 * * 1 /bin/bash -l -c 'cd /path/to/code && bin/rails runner -e production '\\''HappyMondayJob.run'\\'' >> /path/to/logs/HappyMondayJob_`date +\\%Y-\\%m-\\%d`.log 2>&1'

15 16 25 * * /bin/bash -l -c 'cd /path/to/code && bin/rails runner -e production '\\''PaydayJob.run'\\'' >> /path/to/logs/PaydayJob_`date +\\%Y-\\%m`.log 2>&1'
    CRONTAB
  end
end
