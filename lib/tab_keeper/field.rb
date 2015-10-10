module TabKeeper
  class Field
    def initialize(value)
      @value = value
    end

    def to_s
      return '*' if all?
      return @value.to_s if @value.is_a?(Fixnum)
      return present_range if range?
      return @value.map { |item| self.class.new(item).to_s }.join(',') if list?
      raise ArgumentError, "Unknown field type #{@value.class.name}"
    end

    private

    def present_range
      "#{self.class.new(@value.min).to_s}-#{self.class.new(@value.max).to_s}"
    end

    def all?
      @value.nil?
    end

    def list?
      @value.is_a?(Array)
    end

    def range?
      @value.is_a?(Range)
    end
  end
end
