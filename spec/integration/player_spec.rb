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
    end
    
    it "should show the room's description when moving" do
      input 'east'
      @client.should be_displayed(@r2.full_description)
    end
    
    it "should display messages when moving" do
      r1_client = MockClient.new
      r2_client = MockClient.new
      r1_client.login_to_player Factory.build(:player, :name => "r1_player")
      r2_client.login_to_player Factory.build(:player, :name => "r2_player")
      
      r1_client.player.character.set_room(@r1)
      r2_client.player.character.set_room(@r2)
      
      input 'east'
      
      @client.should be_displayed("You move east.")
      @client.should_not be_displayed("#{@player.name} moves to the east.")
      @client.should_not be_displayed("#{@player.name} enters from the west.")
      
      r1_client.should be_displayed("#{@player.name} moves to the east.")
      r1_client.should_not be_displayed("You move east.")
      r1_client.should_not be_displayed("#{@player.name} enters from the west.")
      
      r2_client.should be_displayed("#{@player.name} enters from the west.")
      r2_client.should_not be_displayed("#{@player.name} moves to the east.")
      r2_client.should_not be_displayed("You move east.")
    end 
    
    it "should summon properly with happy messages to all involved" do
      r1_client = MockClient.new
      r2_client = MockClient.new
      r1_client.login_to_player Factory.create(:player, :name => "r1_player")
      r2_client.login_to_player Factory.create(:player, :name => "r2_player")
      
      r1_client.player.character.set_room(@r1)
      r2_client.player.character.set_room(@r2)
      
      input 'who'
      input 'summon r2_player'
      
      @client.should be_displayed("You summon r2_player through your magical portal.")
      # @client.should_not be_displayed("#{@player.name} moves to the east.")
      # @client.should_not be_displayed("#{@player.name} enters from the west.")
      
      r1_client.should be_displayed("Suddenly, r2_player appears through a glowing red portal, summoned by #{@player.name}.")
      # r1_client.should_not be_displayed("You move east.")
      # r1_client.should_not be_displayed("#{@player.name} enters from the west.")
      
      r2_client.should be_displayed("You are sucked through the ether toward #{@player.name}.")
      # r2_client.should_not be_displayed("#{@player.name} moves to the east.")
      # r2_client.should_not be_displayed("You move east.")
    end
  end
  
end