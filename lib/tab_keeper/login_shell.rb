module TabKeeper
  class LoginShell
    def initialize(previous, job: nil, code_directory: nil, **_options)
      @command = previous || job
      @code_directory = code_directory
      return if code_directory
      raise ArgumentError, "code `directory` must be configured for LoginShell"
    end

    def to_s
      "/bin/bash -l -c 'cd #{escaped_path} && #{escaped_command}'"
    end

    private

    def escaped_path
      @code_directory.chars.map { |char| char == "'" ? "'\\''" : char }.join
    end

    def escaped_command
      @command.chars.map { |char| char == "'" ? "'\\''" : char }.join
    end
  end
end
