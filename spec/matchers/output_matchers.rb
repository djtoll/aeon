module OutputMatchers
  
  class OutputMatcher
    def initialize(expected, type)
      @type = type
      case type
      when :prompt
        @expected_output = "\n#{expected}"
      when :display
        @expected_output = "\n#{expected}\n"
      end
    end

    def matches?(client)
      @last_output = client.output.last
      @last_output == @expected_output
    end

    def failure_message
      case @type
      when :prompt
        msg =  "expected prompt: #{@expected_output.inspect}\n"
        msg << "            got: #{@last_output.inspect}"
      when :display
        msg =  "expected display: #{@expected_output.inspect}\n"
        msg << "             got: #{@last_output.inspect}"
      end
      msg
    end

    def negative_failure_message
      "didn't expect: #{@last_output.inspect}\n"
    end
  end
  
  
  
  def be_prompted(expected)
    OutputMatcher.new(expected, :prompt)
  end
  
  def be_displayed(expected)
    OutputMatcher.new(expected, :display)
  end
  
end