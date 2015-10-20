module TabKeeper
  class RailsRunner
    def initialize(previous, job: nil, rails_env: nil, **_options)
      @to_run = previous || job
      @rails_env = rails_env
    end

    def to_s
      ["bin/rails runner", env_part, "'#{escaped_previous}'"].compact.join(" ")
    end

    private

    attr_reader :rails_env, :to_run

    def env_part
      return unless @rails_env
      "-e #{rails_env}"
    end

    def escaped_previous
      to_run.chars.map { |char| char == "'" ? "'\\''" : char }.join
    end
  end
end
