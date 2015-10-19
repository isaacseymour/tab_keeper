module TabKeeper
  class LogRedirection
    def initialize(previous, job: nil, timing: nil, log_directory: nil, error_suffix: nil,
                   **_options)
      if previous.nil?
        raise ArgumentError, "#{self.class.name} must not be first in the cron pipeline!"
      end

      if log_directory.nil?
        raise ArgumentError, "log_directory must be set for #{self.class.name}"
      end

      @previous = previous
      @job = job
      # Normalise the job name: if it's an array take the first thing, then get the last
      # thing after a "::" (if it's a class name), or a "/" (if it's a script, and removes
      # the need to escape yay)
      job_name = Array(@job).first.to_s.split(/((::)|\/)/).last
      @job_name = block_given? ? yield(job_name) : job_name
      @timing = timing
      @log_directory = log_directory
      @error_suffix = error_suffix
    end

    def to_s
      "#{@previous} " \
        ">> #{@log_directory}/#{job_name}_`date +#{date_format}`.log " \
        "2>#{error_part}"
    end

    private

    attr_reader :job_name

    def error_part
      return "&1" unless @error_suffix
      "> #{@log_directory}/#{job_name}_`date +#{date_format}`.#{@error_suffix}.log"
    end

    def date_format
      [
        '%Y',
        '%m',
        day_component,
        hour_component,
        min_component,
        second_component
      ].compact.join('-').chars.map { |char| char == '%' ? '\%' : char }.join
    end

    def day_component
      '%d' if more_than_once_a_month?
    end

    def hour_component
      '%H' if more_than_once_a_day?
    end

    def min_component
      '%m' if more_than_once_a_day?
    end

    def second_component
      '%s' if more_than_once_an_hour?
    end

    MULTIPLE_CHARACTERS = "*-/,".chars.map(&:freeze).freeze

    def more_than_once_a_month?
      MULTIPLE_CHARACTERS.any? { |char| @timing.split(' ')[2].include?(char) }
    end

    def more_than_once_a_day?
      MULTIPLE_CHARACTERS.any? { |char| @timing.split(' ').first(2).join.include?(char) }
    end

    def more_than_once_an_hour?
      MULTIPLE_CHARACTERS.any? { |char| @timing.split(' ').first.include?(char) }
    end
  end
end
