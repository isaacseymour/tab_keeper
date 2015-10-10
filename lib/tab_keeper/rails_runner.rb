module TabKeeper
  class RailsRunner
    def initialize(previous, job: nil, rails_env: nil, **_options)
      @to_run = previous || job
      @rails_env = rails_env
      verify!
    end

    def to_s
      "bin/rails runner -e #{rails_env} '#{escaped_previous}'"
    end

    private

    attr_reader :rails_env, :to_run

    def escaped_previous
      to_run.chars.map { |char| char == "'" ? "\\'" : char }.join
    end

    def verify!
      return if rails_env
      raise ArgumentError, "RailsRunner requires a rails_env to be configured"
    end
  end
end
