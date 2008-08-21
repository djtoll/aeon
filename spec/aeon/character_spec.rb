require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::Character do
  before(:each) do
    DataMapper.auto_migrate! # reset database after each example
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
  
  it "should not allow a nil room association by defaulting it to the first room in the database" do
    Aeon::Room.create(:name => "Test Room", :description => "Irrelevent description")
    @character.room.should_not be_nil
    @character.room = nil
    @character.room.should == Aeon::Room.first
  end
  
  describe "#say" do
    it "should show the player the result" do
      @player.animate(@character)
      @player.should_receive(:display).with("TestPlayer says, \"Hello\"")
      @character.say("Hello")
    end
  end
  
end