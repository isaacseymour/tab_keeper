module TabKeeper
  class Daily
    HOUR_VALUES = (0..23)
    MINUTE_VALUES = (0..59)

    def initialize(hour: nil, min: 0)
      @hour = hour
      @min = min
      validate!
    end

    def to_s
      "#{min} #{hour} * * *"
    end

    private

    attr_reader :hour, :min

    def validate!
      unless HOUR_VALUES.include?(hour)
        raise ArgumentError, "hour must be between 0 and 23"
      end

      unless MINUTE_VALUES.include?(min)
        raise ArgumentError, "min must be between 0 and 59"
      end
    end
  end
end
