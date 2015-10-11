module TabKeeper
  class JobList
    def initialize
      @jobs = []
      yield self if block_given?
    end

    def to_a
      @jobs
    end

    def add(job, timer)
      # TODO: validate `timer.to_s`
      @jobs << [job, timer.to_s]
    end

    def daily(job, **options)
      add(job, Daily.new(**options))
    end

    def hourly(job, **options)
      add(job, Hourly.new(**options))
    end

    def minutely(job, **options)
      add(job, Minutely.new(**options))
    end

    def monthly(job, **options)
      add(job, Monthly.new(**options))
    end

    def weekly(job, **options)
      add(job, Weekly.new(**options))
    end
  end
end
