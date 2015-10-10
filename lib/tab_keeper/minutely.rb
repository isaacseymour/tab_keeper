module TabKeeper
  class Minutely
    # Other values would lead to the non-evenly spaced runs, which is non-obvious
    EVERY_VALUES = [2, 3, 4, 5, 6, 10, 12, 15, 20, 30]

    def initialize(every: nil)
      @every = every
      verify!
    end

    def to_s
      return "* * * * *" unless every
      "*/#{every} * * * *"
    end

    private

    attr_reader :every

    def verify!
      return if every.nil? || EVERY_VALUES.include?(every)
      raise ArgumentError, "every must be nil, or one of #{EVERY_VALUES.join(', ')}"
    end
  end
end
