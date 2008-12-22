require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::Player, "[Integration]" do
  
  before(:each) do
    @world = Aeon::World.new
    @character = Aeon::Character.create(
      :name => "TestPlayer"
    )
    @player = Aeon::Player.create(
      :name      => "TestPlayer",
      :password  => "secret",
      :character => @character
    )
    
    @client = MockClient.new
    @client.login_to_player(@player)
  end
  
  def input(data)
    @client.receive_data(data)
  end
  
  
  describe "moving rooms" do
    before(:each) do
      @room_start = Aeon::Room.new(
        :name => 'Start Room',
        :description => 'You are in the starting room.'
      )
      @room_east = Aeon::Room.new(
        :name => 'Eastern Room',
        :description => 'You are in the eastern room.'
      )
      @room_start.link(:east, @room_east)
    end
  
    it "should display the room's description when moving" do
      @character.room = @room_start
      input 'east'
      @character.room.should == @room_east
      @client.should be_displayed(@room_east.full_description)
    end
  end
  
  # describe "commands" do
  #   it "should show the who list" do
  #     input 'who'
  #     @client.should be_displayed "Asdfs"
  #   end
  # end
end