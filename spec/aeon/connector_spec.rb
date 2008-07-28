require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::Connector do
  
  before(:each) do
    @client = MockClient.new
  end
  
  it "should prompt for the player's username" do
    @connector = Aeon::Connector.new(@client)
    @client.should be_prompted("What is your name, wanderer? > ")
  end
  
  it "should find an existing player using the specified username" do
    # TODO: make non-case-sensitive?
    name = "TestPlayer"
    Aeon::Player.should_receive(:first).with(:name => name)
    @connector = Aeon::Connector.new(@client)
    @connector.handle_input(name)
  end
  
  it "should ask for the username again if no user found (for now)" do  
    Aeon::Player.should_receive(:first).and_return(nil)
    @connector = Aeon::Connector.new(@client)
    @connector.handle_input("BogusPlayer")
    @client.should be_displayed("No player found by that name.")
    @client.should be_prompted("What is your name, wanderer? > ")
  end
  
  it "should log in a valid player and tell the client to animate it" do
    DataMapper.auto_migrate!
    @player    = Aeon::Player.create(:name => "TestPlayer", :password => "secret")
    @connector = Aeon::Connector.new(@client)
    
    @connector.handle_input(@player.name)
    @client.should be_prompted("OK, give me a password for #{@player.name} > ")

    @client.should_receive(:animate).with(@player)
    @connector.handle_input(@player.password)
    @client.should be_displayed("Welcome to Aeon, TestPlayer.")
  end
  
  it "should return to the login username prompt if login fails" do
    player = mock("Player", :name => "TestPlayer", :password => 'secret')
    Aeon::Player.stub!(:first).and_return(player)
    Aeon::Player.should_receive(:authenticate).and_return(false)
    @connector = Aeon::Connector.new(@client)
    @connector.handle_input(player.name)
    @connector.handle_input('faulty_password')
    @client.should be_displayed("Password Incorrect.")
    @client.should be_prompted("What is your name, wanderer? > ")
  end
  
end