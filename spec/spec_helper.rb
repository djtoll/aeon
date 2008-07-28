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
  
  attr_reader :transcript

  # the transcript is an associative array of input and output
  #   [[:input, 'foo'], [:output, 'bar']]
  def initialize
    @transcript = []
  end
  
  # #output and #input search the recorded transcript
  def output
    @transcript.collect {|e| e[1] if e[0] == :output}.compact
  end
  def input
    @transcript.collect {|e| e[1] if e[0] == :input}.compact
  end
  
  # Returins a string of a nicely formatting transcript. width is 80 columns.
  def pretty_transcript
    msg =  "\n===============================<( TRANSCRIPT )>=================================\n".white.bold
    @transcript.each do |e|
      msg << "> #{e[1]}\n".yellow  if e[0] == :input
      msg << e[1]                  if e[0] == :output
    end
    msg << "\n================================================================================\n".white.bold
    msg
  end
  
  # add received data to the transcript as input
  def receive_data(data)
    @transcript << [:input, data]
    super(data)
  end
  
  # add received data to the transcript as input
  def send_data(data)
    @transcript << [:output, data]
  end
end