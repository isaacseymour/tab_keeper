module TabKeeper
  class Generator
    def initialize(*pipeline)
      @pipeline = pipeline.flatten
    end

    def generate(job_list, **options)
      job_list.map do |job, timing|
        timing + " " + cron_escape(apply_pipeline(job, timing, **options))
      end.join("\n\n") + "\n"
    end

    private

    def apply_pipeline(job, timing, **options)
      @pipeline.reduce(nil) do |previous, pipe|
        pipe.new(previous, job: job, timing: timing, **options).to_s
      end
    end

    def cron_escape(input)
      input.chars.map { |char| char == '%' ? "\\%" : char }.join
    end
  end
end
