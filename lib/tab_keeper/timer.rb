module TabKeeper
  class Timer
    def initialize(minute: nil, hour: nil, day_of_month: nil, month: nil, day_of_week: nil)
      @minute = minute
      @hour = hour
      @day_of_month = day_of_month
      @month = month
      @day_of_week = day_of_week
    end

    def to_s
      parts.map { |part| Field.new(part).to_s }.join(" ")
    end

    private

    def parts
      [@minute, @hour, @day_of_month, @month, @day_of_week]
    end
  end
end
