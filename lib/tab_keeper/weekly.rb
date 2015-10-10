module TabKeeper
  class Weekly
    MINUTE_VALUES = (0..59)
    HOUR_VALUES = (0..23)
    # Order matters here - it must match the ordering used by cron (i.e. 0 = Sunday)
    DAY_VALUES = %i(sunday monday tuesday wednesday thursday friday saturday)

    def initialize(day: nil, hour: nil, min: 0)
      @day = day
      @hour = hour
      @min = min
      verify!
    end

    def to_s
      "#{min} #{hour} * * #{day_index}"
    end

    private

    attr_reader :day, :hour, :min

    def day_index
      return day if day.is_a?(Fixnum)
      DAY_VALUES.index(day)
    end

    def verify!
      unless MINUTE_VALUES.include?(min)
        raise ArgumentError, "min must be between 0 and 59"
      end

      unless HOUR_VALUES.include?(hour)
        raise ArgumentError, "hour must be between 0 and 23"
      end

      return if DAY_VALUES.include?(day) || (day.is_a?(Fixnum) && DAY_VALUES[day])
      raise ArgumentError, "day must be between 0 and 6, or a symbol day name"
    end
  end
end
