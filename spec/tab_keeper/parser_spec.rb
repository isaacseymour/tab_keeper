RSpec.describe TabKeeper::Parser do
  subject { described_class.new(english).to_s }

  context do
    let(:english) { "every day at midnight" }
    it { is_expected.to eq("0 0 * * *") }
  end

  context do
    let(:english) { "every 15 minutes at noon" }
    it { is_expected. to eq("*/15 12 * * *") }
  end

  context do
    let(:english) { "every 2nd day in April at 3:30" }
    it { is_expected. to eq("30 3 2 4 *") }
  end

  context do
    let(:english) { "every day on Monday at 3:30" }
    it { is_expected. to eq("30 3 * * 1") }
  end

  context do
    let(:english) { "every day on the weekday at 3:30" }
    it { is_expected. to eq("30 3 * * 1-5") }
  end

  context do
    let(:english) { "every 3 days in July on the weekend at 6:57" }
    it { is_expected. to eq("57 6 */3 7 0,6") }
  end

  context "switching connectors" do
    context do
      let(:english) { "Every other month on the weekday at midnight" }
      it { is_expected. to eq("0 0 * */2 1-5") }
    end

    context do
      let(:english) { "Every other month at midnight on the weekday" }
      it { is_expected. to eq("0 0 * */2 1-5") }
    end
  end

  context "using the last keyword" do
    context do
      let(:english) { "Every month on the last Saturday" }
      it { is_expected. to eq("* * * * 6L") }
    end

    context do
      let(:english) { "Every last day" }
      it { is_expected. to eq("* * L * *") }
    end

    context do
      let(:english) { "Every last month" }
      it { is_expected.to raise_error(ArgumentError) }
    end
  end

  context "lists" do
    context do
      let(:english) { "every day in April, June, and August at midnight" }
      it { is_expected. to eq("0 0 * 4,6,8 *") }
    end

    context do
      let(:english) { "every month at midnight and noon on Sunday" }
      it { is_expected. to eq("0 0,12 * * 0") }
    end

    context do
      let(:english) { "every 3 hours on Monday, Wednesday, and Friday" }
      it { is_expected. to eq("* */3 * * 1,3,5") }
    end

    context do
      let(:english) { "every month on the 1st, 3rd, 4th, and 8th days" }
      it { is_expected. to eq("* * 1,3,4,8 * *") }
    end

    context do
      let(:english) { "every day at 1am, 4am, 12pm, and 1pm" }
      it { is_expected. to eq("0 1,4,12,13 * * *") }
    end
  end

  context "ranges" do
    context do
      let(:english) { "every day in January through October" }
      it { is_expected. to eq("* * * 1-10 *") }
    end

    context do
      let(:english) { "every day in January to October" }
      it { is_expected. to eq("* * * 1-10 *") }
    end

    context do
      let(:english) { "every day in January-October" }
      it { is_expected. to eq("* * * 1-10 *") }
    end

    context do
      let(:english) { "every month on Wednesday through Saturday" }
      it { is_expected. to eq("* * * * 3-6") }
    end

    context do
      let(:english) { "every month on Wednesday to Saturday" }
      it { is_expected. to eq("* * * * 3-6") }
    end

    context do
      let(:english) { "every month on Wednesday-Saturday" }
      it { is_expected. to eq("* * * * 3-6") }
    end
  end

  context "special words" do
    let(:english) { "every other day at midnight to noon" }
    it { is_expected. to eq("0 0-12 */2 * *") }
  end

  context do
    let(:english) { "every 3 minutes at 1am-8pm" }
    it { is_expected. to eq("*/3 1-20 * * *") }
  end

  context do
    let(:english) { "every 3 minutes at 1am-8pm in the year 2013" }
    it { is_expected. to eq(be === "2013") }
  end

  context do
    let(:english) { "every day in every month at midnight" }
    it { is_expected. to eq("0 0 * * *") }
  end

  context do
    let(:english) { "every last day in every month at every 4 hours" }
    it { is_expected. to eq("* */4 L * *") }
  end

  context do
    let(:english) { "every month on the last day at every 4 hours" }
    it { is_expected. to eq("* */4 L * *") }
  end

  context do
    let(:english) { "every Friday on the last day in every month at midnight" }
    it { is_expected. to eq("0 0 L * 5") }
  end

  context do
    let(:english) { "every month on the last Friday at midnight" }
    it { is_expected. to eq("0 0 * * 5L") }
  end

  context do
    let(:english) { "every month on the 2nd Friday at midnight" }
    it { is_expected. to eq("0 0 * * 5#2") }
  end

  context do
    let(:english) { "every last Friday at midnight" }
    it { is_expected. to eq("0 0 * * 5L") }
  end

  context do
    let(:english) { "every other Friday at midnight" }
    it { is_expected. to eq("0 0 * * 5/2") }
  end
end
