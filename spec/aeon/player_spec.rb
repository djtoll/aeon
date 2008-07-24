require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::Player do
  before do
    @player = Aeon::Player.new(:name => 'TestPlayer')
  end
  
  it "should have a name" do
    @player.name.should == "TestPlayers"
  end
end