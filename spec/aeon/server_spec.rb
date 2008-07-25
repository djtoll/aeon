require File.dirname(__FILE__) + '/../spec_helper'
require 'socket'
require 'thread'

describe Aeon::Server do
  it "should accept TCP connections" do
    server = Thread.new { Aeon::Server.start }
    lambda { TCPSocket.new('localhost', 5000) }.should_not raise_error
    server.exit
  end
end
