module OutputMatchers
  
  class BePrompted
    def initialize(expected)
      @expected = "\n#{expected}"
    end

    def matches?(client)
      @client = client
      @output = client.output
      @output.last == @expected
    end

    def failure_message
      msg = "expected prompt: #{@expected.inspect}\n"
      msg << @client.pretty_transcript
    end

    def negative_failure_message
      "didn't expect: #{@output.last.inspect}\n"
    end
  end
  
  
  class BeDisplayed
    def initialize(expected)
      @expected = "\n#{expected}\n"
    end

    def matches?(client)
      @client = client
      @output = client.output
      
      return false if @output.nil? || @output.empty?
      
      if @output.length == 1
        @output.include? @expected
      else
        @output[-2..-1].include? @expected
      end
    end

    def failure_message
      msg = "expected display: #{@expected.inspect}\n"
      msg << @client.pretty_transcript
    end

    def negative_failure_message
      "didn't expect: #{@output.last.inspect}\n"
    end
  end
  
  
  def be_prompted(expected)
    BePrompted.new(expected)
  end
  
  def be_displayed(expected)
    BeDisplayed.new(expected)
  end
  
end