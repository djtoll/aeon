require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::World do
  before(:each) do
    @world = Aeon::World.new
  end
  
  it "should add a player to its list of players" do
    lambda { 
      @world.add_player(mock("Player")) 
    }.should change(@world.players, :length).by(1)
  end
  
  it "should remove a player from its list of players" do
    player = mock("Player")
    @world.add_player(player)
    lambda { 
      @world.remove_player(player) 
    }.should change(@world.players, :length).by(-1)
  end
  
end