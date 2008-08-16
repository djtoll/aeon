require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::Connector, "when logging in a player" do
  
  before(:each) do
    DataMapper.auto_migrate!
    @client = MockClient.new
    @world  = Aeon::World.new
  end
  
  it "should prompt for the player's name" do
    @connector = Aeon::Connector.new(@client, @world)
    @client.should be_prompted("What is your name, wanderer? > ")
  end
  
  it "should find an existing player using the specified player name" do
    # TODO: make non-case-sensitive?
    name = "TestPlayer"
    Aeon::Player.should_receive(:first).with(:name => name)
    @connector = Aeon::Connector.new(@client, @world)
    @connector.handle_input(name)
  end
  
  it "should ask for the username again if no user found (for now)" do  
    Aeon::Player.should_receive(:first).and_return(nil)
    @connector = Aeon::Connector.new(@client, @world)
    @connector.handle_input("BogusPlayer")
    @client.should be_displayed("No player found by that name.")
    @client.should be_prompted("What is your name, wanderer? > ")
  end
  
  it "should prompt for the player's password" do
    @player    = Aeon::Player.create(:name => "TestPlayer", :password => "secret")
    @connector = Aeon::Connector.new(@client, @world)
    @connector.handle_input(@player.name)
    @client.should be_prompted("OK, give me a password for #{@player.name} > ")
  end
  
  it "should return to the login username prompt if login fails" do
    @player    = Aeon::Player.create(:name => "TestPlayer", :password => "secret")
    @connector = Aeon::Connector.new(@client, @world)
    @connector.handle_input(@player.name)
    @connector.handle_input('faulty_password')
    @client.should be_displayed("Password Incorrect.")
    @client.should be_prompted("What is your name, wanderer? > ")
  end
  
  it "should log in a valid player and tell the client to animate it" do
    @player    = Aeon::Player.create(:name => "TestPlayer", :password => "secret")
    @connector = Aeon::Connector.new(@client, @world)
    @client.should_receive(:animate).with(@player)  
    @connector.handle_input(@player.name)
    @connector.handle_input(@player.password)
    @client.should be_displayed("Welcome to Aeon, TestPlayer.")
  end
  
  it "should add the player to the world's player registry" do
    @player    = Aeon::Player.create(:name => "TestPlayer", :password => "secret")
    @connector = Aeon::Connector.new(@client, @world)
    lambda {
      @connector.handle_input(@player.name)
      @connector.handle_input(@player.password)
    }.should change(@world.players, :length).by(1)
  end
  
end