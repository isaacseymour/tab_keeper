module TabKeeper
  class Generator
    def initialize(*pipeline)
      @pipeline = pipeline.flatten
    end

    def generate(job_list, **options)
      job_list.map do |job, timing|
        timing + " " + @pipeline.reduce(nil) do |previous, pipe|
          pipe.new(previous, job: job, timing: timing, **options).to_s
        end
      end.join("\n\n") + "\n"
    end
  end
end
