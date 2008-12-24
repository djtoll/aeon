require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::Player do
  before(:each) do
    @player = Aeon::Player.new(:name => 'TestPlayer')
  end

  it "should persist to the database" do
    @player.save.should be_true
    Aeon::Player.first.should == @player
  end
  
  it "should authenticate with the correct username and password" do
    player = Aeon::Player.create(:name => 'TestPlayer', :password => 'secret')
    Aeon::Player.authenticate('TestPlayer', 'secret').should == player
  end
end
  
describe Aeon::Player, "controlling a character" do
  before(:each) do
    @player = Aeon::Player.new(
      :name      => 'TestPlayer', 
      :character => Aeon::Character.new
    )
  end
  
  it "should animate a character" do
    @player.character.should_receive(:become_animated)
    @player.animate
  end
  
  it "should deanimate a character" do
    @player.character.should_receive(:become_animated)
    @player.animate
    @player.character.should_receive(:become_deanimated)
    @player.deanimate
  end
end