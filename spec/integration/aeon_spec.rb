require File.dirname(__FILE__) + '/../spec_helper'

describe "[Integration] Aeon" do
  before(:each) do
    DataMapper.auto_migrate!
    @character = Aeon::Character.create(
      :name => "TestPlayer"
    )
    @player = Aeon::Player.create(
      :name      => "TestPlayer",
      :password  => "secret",
      :character => @character
    )
    @client = MockClient.new
  end
  
  def input(data)
    @client.receive_data(data)
  end
  
  def login
    input 'TestPlayer'
    input 'secret'
  end
  
  it "should log in the player" do
    login
    @client.should be_displayed("Welcome to Aeon, TestPlayer.")
    @client.player.should == @player
  end
  
  it "should log in the player and animate their character" do
    @client.login_to_player(@player)
    @player.animated_object.should == @character
  end
  
  it "should place a player's animated object into a room" do
    Aeon::Room.create(:name => "Foo Room")
    @client.login_to_player(@player)
    @player.animated_object.room.should_not be_nil
  end
  
  it "should place two characters into the same room object" do
    room = Aeon::Room.create(:name => "Foo Room")
    
    client2 = MockClient.new
    character2 = Aeon::Character.create(:name => "Bob")
    player2 = Aeon::Player.create(:name => "Bob", :character => character2)
    
    @client.login_to_player(@player)
    client2.login_to_player(player2)
    
    character2.room.object_id.should == @character.room.object_id
  end
  
  it "should disconnect a client if another client logs into the same player" do
    @client.login_to_player(@player)
    
    @client.should_receive(:force_disconnect)
    
    @client2 = MockClient.new
    @client2.login_to_player(@player)
  end
  
  # describe "moving rooms" do
  #   before(:each) do
  #     @room_start = Aeon::Room.new(
  #       :name => 'Start Room',
  #       :description => 'You are in the starting room.'
  #     )
  #     @room_east = Aeon::Room.new(
  #       :name => 'Eastern Room',
  #       :description => 'You are in the eastern room.'
  #     )
  #     @room_start.link_with(@room_east, :east)
  #     @client.login_to_player(@player)
  #   end
  #   
  #   it "should move to the east and display the room's description" do
  #     @character.room = @room_start
  #     input 'east'
  #     # @client.should be_displayed "You move east."
  #     @character.room.should == @room_east
  #     @client.should be_displayed <<-EOS
  #       Eastern Room
  #       You are in the eastern room.
  #     EOS
  #   end
  # end
end