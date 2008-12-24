# MockClient is my attempt to mock a client connection, which is normally
# an instance of EventMachine::Connection. I'm overwriting the #send_data
# method -- the method provided by EventMachine::Connection that actually
# sends data to the client. Here I'm just capturing it in an output buffer so
# that my tests can examine output easily.
#
# This may not be best practice at all and is subject to change.
require 'colored'
class MockClient
  include Aeon::Client
  
  attr_reader :transcript, :input, :output

  def initialize
    @transcript = []
    @output     = []
    @input      = []
    post_init
  end
  
  # Returns a string of a nicely formatted transcript. Width is 80 columns,
  # and may explode all over the place if text is wider than that.
  #
  # Here's an example of what that looks like:
  #
  #   +==============================<( TRANSCRIPT )>====================================+
  #   | What is your name, wanderer? > "TestPlayer\n"                                    
  #   | No player found by that name.                                                    
  #   |                                                                                  
  #   | What is your name, wanderer? >                                                   
  #   +==================================================================================+
  #
  def pretty_transcript
    msg =  "\n<==============================<( TRANSCRIPT )>====================================>\n".white.bold
    # Join the transcript and strip any leading or trailing whitespace.
    # IMPORTANT: We're also inserting a "|" at each newline. This is actually
    # necessary for this to be output in Autotest, because it chokes if there
    # are blank lines and ends up not correctly reporting failed tests.
    msg << "| " << @transcript.join.strip.split("\n").join("\n| ")
    msg << "\n<==================================================================================>\n".white.bold
    msg
  end
  
  def output_lines
    @output.join.split("\n")
  end
  
  # add received data to the transcript as input
  def receive_data(data)
    @transcript << "#{data.inspect}".yellow
    @input << data
    super(data)
  end
  
  # add received data to the transcript as output
  def send_data(data)
    @transcript << data
    @output << data
  end
end