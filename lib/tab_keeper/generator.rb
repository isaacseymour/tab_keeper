module TabKeeper
  class Generator
    def initialize(*pipeline)
      @pipeline = pipeline.flatten
    end

    def generate(job_list, **options)
      rows = rows(job_list, **options)
      validate_rows!(rows)
      rows.join("\n\n") + "\n"
    end

    private

    def validate_rows!(rows)
      too_long_rows = rows.reject { |row| row.length < 900 }
      return unless too_long_rows.any?
      raise "The following rows are too long for a cron file, and may be truncated:\n" \
            "#{too_long_rows.join("\n\n")}"
    end

    def rows(job_list, **options)
      job_list.map do |job, timing|
        timing + " " + cron_escape(apply_pipeline(job, timing, **options))
      end
    end

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
