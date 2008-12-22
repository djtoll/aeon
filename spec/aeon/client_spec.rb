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
  
  it "should display text with a newline before and after" do
    @client.should_receive(:send_data).with("\nFoo Data\n")
    @client.display("Foo Data")
  end
  
  it "should send input data to the Connector if no Player is logged in" do
    connector = mock("Connector")
    Aeon::Connector.should_receive(:new).and_return(connector)
    @client.post_init # simulate client connecting
    connector.should_receive(:handle_input)
    @client.receive_data("Foo")
  end
  
  it "should send input data to its logged in Player" do
    player = mock("Player", :login => true)
    @client.login_to_player(player)
    
    player.should_receive(:handle_input).with("Foo")
    @client.receive_data("Foo")
  end
  
  it "should login a player" do
    player = mock("Player")
    player.should_receive(:login)
    @client.login_to_player(player)
  end
  
end