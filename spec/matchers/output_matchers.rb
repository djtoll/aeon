module OutputMatchers
  
  class BePrompted
    def initialize(expected)
      @expected_output = "\n#{expected}"
    end

    def matches?(client)
      @full_output = client.output
      @last_output = client.output.last
      
      @last_output == @expected_output
    end

    def failure_message
      msg =  "expected prompt: #{@expected_output.inspect}\n"
      msg << "            got: #{@last_output.inspect}"
      msg
    end

    def negative_failure_message
      "didn't expect: #{@last_output.inspect}\n"
    end
  end
  
  
  class BeDisplayed
    def initialize(expected)
      @expected_output = "\n#{expected}\n"
    end

    def matches?(client)
      @full_output = client.output
      @last_output = client.output.last

      @full_output[-2..-1].include? @expected_output
    end

    def failure_message
      msg =  "expected display: #{@expected_output.inspect}\n"
      msg << "   actual output:\n"
      msg << "   ------------------------------------------"
      msg << @full_output.join.split("\n").join("\n   >> ")
    end

    def negative_failure_message
      "didn't expect: #{@last_output.inspect}\n"
    end
  end
  
  
  def be_prompted(expected)
    BePrompted.new(expected)
  end
  
  def be_displayed(expected)
    BeDisplayed.new(expected)
  end
  
end