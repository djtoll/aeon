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
    Aeon::Player.first.should == @player
  end
  
  it "should authenticate with the correct username and password" do
    player = Aeon::Player.create(:name => 'TestPlayer', :password => 'secret')
    Aeon::Player.authenticate('TestPlayer', 'secret').should == player
  end
  
  it "should create an associated Character on create" do
    @player.save
    @player.character.should be_an_instance_of(Aeon::Character)
    @player.id.should == @player.character.player_id
  end
  
  it "should also allow an associated character to be manually assigned" do
    char = Aeon::Character.new(:name => "TestCharacter")
    @player.character = char
    @player.save
    @player.character.should === char
  end
end

describe Aeon::Player, "logging in" do
  before(:each) do
    @player = Aeon::Player.new(:name => 'TestPlayer')
    @client = MockClient.new
    @client.login(@player)
  end
  
  it "should prompt after login" do
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
  
  it "should place the player in an initial room"
end

describe Aeon::Player, "commands" do
  before(:each) do
    @player = Aeon::Player.new(:name => 'TestPlayer')
    @client = MockClient.new
    @client.login(@player)
  end
  
  it "should respond 'Huh?' to unknown commands" do
    @client.receive_data('totally_made_up_command')
    @client.should be_displayed('Huh?')
  end
  
  it "should display the 'whoami' command" do
    @client.receive_data('whoami')
    @client.should be_displayed('You are TestPlayer.')
  end
  
  it "should close the connection with the 'quit' command" do
    @client.should_receive(:close_connection_after_writing)
    @client.receive_data('quit')
    @client.should be_displayed('Goodbye!')    
  end

  it "should run the 'ooc' command with args" do
    @player.should_receive('cmd_ooc').with('test message')
    @client.receive_data('ooc test message')
  end
  
  it "should broadcast OOC to all players" do
    @player2 = Aeon::Player.new(:name => 'TestPlayer2')
    @client2 = MockClient.new
    @client2.login(@player2)
    
    @client.receive_data('ooc test message')
    
    @client.should  be_displayed('[OOC] TestPlayer: test message')
    @client2.should be_displayed('[OOC] TestPlayer: test message')
  end
  
  it "should only broadcast OOC to players 'subscribed' to it."

end





