require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::Player do
  before(:each) do
    DataMapper.auto_migrate! # reset DB after every test
    @player = Aeon::Player.new(:name => 'TestPlayer')
  end
  
  it "should have a name" do
    @player.name.should == "TestPlayer"
  end
  
  it "should persist to the database" do
    @player.save.should be_true
    Aeon::Player.first(:name => 'TestPlayer').should == @player
  end
  
  it "should authenticate with the correct username and password" do
    player = Aeon::Player.create(:name => 'TestPlayer', :password => 'secret')
    Aeon::Player.authenticate('TestPlayer', 'secret').should == player
  end
end

describe Aeon::Player, "when animated" do
  before(:each) do
    @player = Aeon::Player.new(:name => 'TestPlayer')
    @client = MockClient.new
    @client.animate(@player)
  end
  
  it "should prompt after becoming animated" do
    @client.should be_prompted("TestPlayer> ")
  end
  
  it "should reprompt if #handle_input receives an empty string" do
    @client.receive_data('')
    @client.should be_prompted('TestPlayer> ')
    @client.receive_data("\n")
    @client.should be_prompted('TestPlayer> ')
    @client.receive_data("\r\n")
    @client.should be_prompted('TestPlayer> ')
    @client.receive_data("\n\n")
    @client.should be_prompted('TestPlayer> ')
  end
end

describe Aeon::Player, "performing commands" do
  before(:each) do
    @player = Aeon::Player.new(:name => 'TestPlayer')
    @client = MockClient.new
    @client.animate(@player)
  end
  
  it "should respond 'Huh?' to unknown commands" do
    @client.receive_data('totally_made_up_command')
    @client.should be_displayed('Huh?')
  end
  
  it "should display the 'whoami' command" do
    @client.receive_data('whoami')
    @client.should be_displayed('You are TestPlayer.')
  end
end