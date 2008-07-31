require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::World do
  before(:each) do
    @world = Aeon::World.new
  end
  
  it "should connect a player" do
    lambda { 
      @world.connect(mock("Player")) 
    }.should change(@world.players, :length).by(1)
  end
  
  it "should disconnect a player" do
    player = mock("Player")
    @world.connect(player)
    lambda { 
      @world.disconnect(player) 
    }.should change(@world.players, :length).by(-1)
  end
  
end