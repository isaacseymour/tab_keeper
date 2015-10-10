module TabKeeper
  class Parser
    MONTH_NAMES = %w(january february march april may june july august september october
                     november december)
    DAY_NAMES = %w(sunday monday tuesday wednesday thursday friday saturday)
    WEEKDAYS = (1...5)
    NOON = 12

    EVERY_MODIFIERS = [
      "\\d{1,2}",
      "1st",
      "2nd",
      "3rd",
      "[4-9]th",
      "\\d{2}th",
      "other"
    ]
    EVERY_PERIODS = %w(minute hour day month)
    EVERY_CLAUSE = /every ((#{EVERY_MODIFIERS.join("|")}) )?(#{EVERY_PERIODS.join("|")})s?/

    DAY_CLAUSE = //

    TIMES = [
      "midnight",
      "noon",
      /(\d{1,2})(:(\d{2}))?(am|pm)?/
    ]
    TIME_CLAUSE = /at (#{TIMES.join("|")})/

    REGEX = /\A#{EVERY_CLAUSE}(#{DAY_CLAUSE} )?#{TIME_CLAUSE}\z/i

    def initialize(english)
      @english = english
    end

    def to_s
      Timer.new(minute: time[1], hour: time[0]).to_s
    end

    private

    def time
      return [0, 0] if match[5] == "midnight"
      return [12, 0] if match[5] == "noon"
      hour = match[6]
      minute = match[8]
      modifier = match[9]

      modifier =~ /pm/i ? [hour.to_i + 12, minute.to_i] : [hour.to_i, minute.to_i]
    end

    def every_unit
      match[3]
    end

    def every_step
      return unless match[2]
      match[2].gsub(/^[0-9]/, '').to_i
    end

    def match
      REGEX.match(@english)
    end
  end
end
