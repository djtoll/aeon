require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::Client do
  before(:each) do
    @client = MockClient.new
  end
  
  it "should respond to post_init, receive_data, unbind" do
    %w(post_init receive_data unbind).each do |meth|
      @client.should respond_to(meth)
    end
  end
  
  it "should prompt text with a newline before" do
    @client.should_receive(:send_data).with("\nFoo")
    @client.prompt("Foo")
  end
  
  it "should display text with a newline before & after" do
    @client.should_receive(:send_data).with("\nFoo Data\n")
    @client.display("Foo Data")
  end
  
  it "should send input data to the Connector if no Player is logged in" do
    @connector = mock("Connector")
    Aeon::Connector.should_receive(:new).and_return(@connector)
    @client.post_init # simulate client connecting
    @connector.should_receive(:handle_input)
    @client.receive_data("Foo")
  end
  
  it "should login a player and add them to the World's player registry" do
    @player = Aeon::Player.new(:name => "TestPlayer")
    @player.should_receive(:animate)
    lambda {
      @client.login_to_player(@player)
    }.should change(Aeon.world.players, :length).by(1)
    @client.should be_displayed("Welcome to Aeon, TestPlayer.")
  end
  
  it "should tell the Player to animate its character on login" do
    
  end
  
  it "should send input data to the logged in Player" do
    @player = Aeon::Player.new
    @player.stub!(:animate)
    @client.login_to_player(@player)
    @player.should_receive(:handle_input).with("Foo")
    @client.receive_data("Foo")
  end
  
end