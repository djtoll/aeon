require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::Character do
  before(:each) do
    DataMapper.auto_migrate!
    @player    = Aeon::Player.new
    @character = Aeon::Character.new
  end
  
  it "should have an associated Player" do
    @character.player = @player
    @character.save
    @character.player.should == @player
  end
  
end