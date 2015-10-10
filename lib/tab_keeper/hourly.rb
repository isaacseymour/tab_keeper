module TabKeeper
  class Hourly
    MINUTE_VALUES = (0..59)
    # Other values don't divide 24, so result in weird behaviour
    EVERY_VALUES = [nil, 2, 3, 4, 6, 8, 12]
    HOUR_VALUES = (0..23)

    def initialize(min: 0, every: nil, only: nil)
      @min = min
      @every = every
      @only = only
      verify!
    end

    def to_s
      return "#{min} */#{every} * * *" if every
      return "#{min} #{only.join(',')} * * *" if only
      "#{min} * * * *"
    end

    private

    attr_reader :min, :every, :only

    def verify!
      unless MINUTE_VALUES.include?(min)
        raise ArgumentError, "min must be between 0 and 59"
      end

      unless EVERY_VALUES.include?(every)
        raise ArgumentError, "every must be one of #{EVERY_VALUES.join(', ')}"
      end

      return if only.nil?
      raise ArgumentError, "every and only don't make sense together!" if every

      raise ArgumentError, "only must be an array" unless only.is_a?(Array)

      raise ArgumentError, "use Daily instead of a single `only` list" if only.one?

      return if only.all? { |hour| HOUR_VALUES.include?(hour) }
      raise ArgumentError, "only must be nil, or a list of hours"
    end
  end
end
