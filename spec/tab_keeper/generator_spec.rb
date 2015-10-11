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

  let(:pipeline) { [TabKeeper::RailsRunner, TabKeeper::LoginShell] }
  let(:options) do
    {
      code_directory: '/path/to/code',
      rails_env: :production
    }
  end

  it do
    is_expected.to eq <<-CRONTAB
*/5 * * * * /bin/bash -l -c 'cd /path/to/code && bin/rails runner -e production \\'FrequentJob.run\\''

0 0 * * * /bin/bash -l -c 'cd /path/to/code && bin/rails runner -e production \\'MidnightJob.run\\''

30 12 * * * /bin/bash -l -c 'cd /path/to/code && bin/rails runner -e production \\'LunchtimeJob.run\\''

30 7 * * 1 /bin/bash -l -c 'cd /path/to/code && bin/rails runner -e production \\'HappyMondayJob.run\\''

15 16 25 * * /bin/bash -l -c 'cd /path/to/code && bin/rails runner -e production \\'PaydayJob.run\\''
    CRONTAB
  end
end
