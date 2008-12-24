require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::Character do
  before(:each) do
    @player    = Aeon::Player.new(:name => "TestPlayer")
    @character = Aeon::Character.new(:name => "TestPlayer")
  end
  
  it "should have an associated Player" do
    @character.player = @player
    @character.save
    @character.player.should == @player
  end
  
  it "should have an associated Room" do
    room = Aeon::Room.new(:name => "Test Room", :description => "Just a test room.")
    @character.room = room
    @character.save
    @character.room.should == room
  end
  
  it "should set its room" do
    room = Aeon::Room.create(:name => "Test Room")
    @character.set_room(room)
    @character.room.should == room
  end
end
