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
    def initialize(expected, type=nil)
      @type = type
      @expected = "\n#{expected}\n"
    end

    def matches?(client)
      @client = client
      @output = client.output
      
      return false if @output.nil? || @output.empty?
      
      if @type == :contains
        expected_lines = @expected.split("\n").collect {|l| l.strip}
        # Reject empty lines
        expected_lines.reject! {|l| l.empty?}
        @client.output_lines.reject! {|l| l.empty?}
        
        # Subtract the expected lines from the output.
        # Did it remove the amount of lines it should have?
        puts (@client.output_lines - expected_lines).size
        puts (@client.output_lines.size - expected_lines.size)
        (@client.output_lines - expected_lines).size == (@client.output_lines.size - expected_lines.size)
      else
        if @output.size == 1
          @output.first == @expected
        else
          @output.include? @expected
        end
      end
    end

    def failure_message
      msg =  "Expected display: #{@expected.inspect}\n"
      msg << "     Output dump: #{@output.inspect}\n"
      msg << @client.pretty_transcript
    end

    def negative_failure_message
      msg =  "Didn't expect: #{@output.inspect}\n"
      msg << "   To contain: #{@expected.inspect}\n"
      msg << @client.pretty_transcript
    end
  end
  
  
  def be_prompted(expected)
    BePrompted.new(expected)
  end
  
  def be_displayed(expected)
    BeDisplayed.new(expected)
  end
  
  def contain_display(expected)
    BeDisplayed.new(expected, :contains)
  end
  
  
end