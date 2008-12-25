require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::Loader do
  it "should reload the code and put players into a new World" do
    world = Aeon::World.new
    c1 = MockClient.new
    c2 = MockClient.new
    
    c1.login_to_player Factory.create(:player, :name => "p1")
    c2.login_to_player Factory.create(:player, :name => "p2")
    
    c1.player.world.should equal(world)
    c2.player.world.should equal(world)
    
    GC.should_receive(:start)
    Aeon::Loader.should_receive(:reload_files)
    Aeon::Loader.reboot!
    
    c1.player.world.should_not equal(world)
    c2.player.world.should_not equal(world)
    c1.player.world.should equal(c2.player.world)
    
    world.players.should == []
    c1.player.world.players.should include(c1.player, c2.player)
  end
end