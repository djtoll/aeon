require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::Room do
  before(:each) do
    @room = Aeon::Room.new(
      :name => 'Test Room 1',
      :description => 'Just a test room!'
    )
    @room_north = Aeon::Room.new(
      :name => 'Test Room 2',
      :description => 'Just another test room!'
    )
  end
  
  it "should link to another room" do     
    @room.link_with(@room_north, :north)
  
    @room.north.should  == @room_north
    @room_north.south.should == @room
    
    @room.north_id.should == @room_north.id
    @room_north.south_id.should == @room.id
  end
  
  it "should not link to a room that's already been linked to in another direction" do
    @room.link_with(@room_north, :north)
    @room.link_with(@room_north, :east).should == false
  end
  
  it "should list the room's exits" do
    @room.link_with(@room_north, :north)
    @room.exits.should == [@room_north, nil, nil, nil]
    
    @room_east = Aeon::Room.new
    @room.link_with(@room_east, :east)
    @room.exits.should == [@room_north, @room_east, nil, nil]
    @room_east.exits.should == [nil, nil, nil, @room]
  end

end