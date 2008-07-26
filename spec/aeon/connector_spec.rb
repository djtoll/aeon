require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::Connector do
  
  before(:each) do
    @client = MockConnection.new
  end
  
  it "should prompt for the player's username" do
    @connector = Aeon::Connector.new(@client)
    @client.should be_prompted("What is your name, wanderer? > ")
  end
  
  it "should find an existing player using the specified username" do
    name = "TestPlayer"
    Aeon::Player.should_receive(:first).with(:name => name)
    @connector = Aeon::Connector.new(@client)
    @connector.handle_input(name)
  end
  
  it "should prompt for the user's password" do
    name = "TestPlayer"
    Aeon::Player.stub!(:first).and_return(mock("Player", :name => name))
    @connector = Aeon::Connector.new(@client)
    @connector.handle_input(name)
    @client.should be_prompted("OK, give me a password for #{name} > ")
  end
  
  
end