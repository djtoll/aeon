require File.dirname(__FILE__) + '/../spec_helper'

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


describe Aeon::Connector do
  
  before(:each) do
    DataMapper.auto_migrate!
    @client = MockConnection.new
  end
  
  def init
    @connector = Aeon::Connector.new(@client)
  end
  
  it "should prompt for the player's username" do
    # @client.should_receive(:prompt).with("What is your name, wanderer?")
    init
    @client.output.last.should == "What is your name, wanderer?"
  end
  
  it "should find an existing player using the specified username" do
    name = "TestPlayer"
    Aeon::Player.should_receive(:first).with(:name => name)
    init
    @connector.handle_input(name)
  end
  
  # it "should prompt for the user's password" do
  #   name = "TestPlayer"
  #   Aeon::Player.stub!(:first).and_return(mock("Player", :name => name))
  #   @client.should_receive(:prompt).with("OK, give me a password for #{name}")
  #   init
  #   @connector.handle_input(name)
  # end
end