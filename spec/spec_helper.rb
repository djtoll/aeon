require 'rubygems'
require 'spec'

# require the Aeon library
require File.dirname(__FILE__) + '/../lib/aeon'

# matchers
require File.dirname(__FILE__) + '/matchers/output_matchers'
include OutputMatchers

# Setup the test database using in-memory SQLite3
require 'dm-core'
DataMapper.setup(:default, 'sqlite3::memory:')


# MockClient is my attempt to mock a client connection, which is normally
# an instance of EventMachine::Connection. I'm overwriting the #send_data
# method -- the method provided by EventMachine::Connection that actually
# sends data to the client. Here I'm just capturing it in an output buffer so
# that my tests can examine output easily.
#
# This may not be bestpractice at all and is subject to change.
require 'colored'
class MockClient
  include Aeon::Client
  
  attr_reader :transcript, :input, :output

  # the transcript is an associative array of input and output
  #   [[:input, 'foo'], [:output, 'bar']]
  def initialize
    @transcript = []
    @output     = []
    @input      = []
  end
  
  # Returns a string of a nicely formatted transcript. width is 80 columns.
  def pretty_transcript
    msg =  "\n+==============================<( TRANSCRIPT )>====================================+\n".white.bold
    # 1. split at newlines with leading & trailing whitespace removed
    # 2. pad each line to be 80 characters, encasing them inside our box
    msg << @transcript.join.strip.split("\n").collect! {|e| "| #{e.ljust(80)} |"}.join("\n")
    msg << "\n+==================================================================================+\n".white.bold
    msg
  end
  
  # add received data to the transcript as input
  def receive_data(data)
    @transcript << ">#{data.inspect}".yellow
    @input << data
    super(data)
  end
  
  # add received data to the transcript as output
  def send_data(data)
    @transcript << data
    @output << data
  end
end