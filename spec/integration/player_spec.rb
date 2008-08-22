require File.dirname(__FILE__) + '/../spec_helper'

describe "[Integration] A Player" do
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
  
  it "should log in the player and animate their character" do
    input 'TestPlayer'
    input 'secret'
    
    @client.should be_displayed("Welcome to Aeon, TestPlayer.")
    @client.player.should == @player
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