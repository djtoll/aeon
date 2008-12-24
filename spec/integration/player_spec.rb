require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::Player, "[Integration]" do
  
  before(:each) do
    @world  = Aeon::World.new
    @player = Factory.build(:player)
    @character = @player.character
    
    @client = MockClient.new
  end
  
  def input(data)
    @client.receive_data(data)
  end
  
  describe "navigating rooms" do
    before(:each) do
      @r1 = Aeon::Room.create(:name => "r1")
      @r2 = @r1.bulldoze(:east, :name => "r2")
      
      @client.login_to_player(@player)
    end
    
    it "should move between rooms" do
      @character.room.should == @r1
      @r1.objects.should include(@character)
      @r2.objects.should_not include(@character)
      
      input 'east'
      
      @character.room.should == @r2
      @r1.objects.should_not include(@character)
      @r2.objects.should include(@character)
      
      @client.should be_displayed(@r2.full_description)
    end
  end
  
end