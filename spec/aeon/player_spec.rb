require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::Player do
  before(:each) do
    DataMapper.auto_migrate! # reset DB after every spec
    @player = Aeon::Player.new(:name => 'TestPlayer')
  end
  
  it "should have a name" do
    @player.name.should == "TestPlayer"
  end
  
  it "should persist to the database" do
    @player.save.should be_true
    Aeon::Player.first(:name => 'TestPlayer').should == @player
  end
  
end