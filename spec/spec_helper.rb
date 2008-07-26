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


# MockConnection is my attempt to mock a client connection, which is normally
# an instance of EventMachine::Connection. I'm overwriting the #send_data
# method -- the method provided by EventMachine::Connection that actually
# sends data to the client. Here I'm just capturing it in an output buffer so
# that my tests can examine output easily.
#
# This may not be bestpractice at all and is subject to change.
require 'spec/mocks'
class MockConnection < Spec::Mocks::Mock
  include Aeon::ConnectionHandler
  
  attr_reader :output
  
  def initialize(stubs={})
    super("MockConnection", stubs)
    @output = []
  end
  
  def send_data(data)
    @output << data
  end
end