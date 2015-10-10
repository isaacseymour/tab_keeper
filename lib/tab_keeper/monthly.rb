module TabKeeper
  class Monthly
    MINUTE_VALUES = (0..59)
    HOUR_VALUES = (0..23)
    # Cron supports 29-31 too, but that's a recipe for sadness
    DAY_VALUES = (0..28)

    def initialize(day: nil, hour: nil, min: 0)
      @day = day
      @hour = hour
      @min = min
      verify!
    end

    def to_s
      "#{min} #{hour} #{day} * *"
    end

    private

    attr_reader :day, :hour, :min

    def verify!
      unless MINUTE_VALUES.include?(min)
        raise ArgumentError, "min must be between 0 and 59"
      end

      unless HOUR_VALUES.include?(hour)
        raise ArgumentError, "hour must be between 0 and 23"
      end

      return if DAY_VALUES.include?(day)
      raise ArgumentError, "day must be between 0 and 28"
    end
  end
end
