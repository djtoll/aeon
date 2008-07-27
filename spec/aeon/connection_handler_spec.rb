require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::ConnectionHandler do
  before(:each) do
    klass = Class.new do
      include Aeon::ConnectionHandler
    end
    @handler = klass.new
  end
  
  it "should respond to post_init, receive_data, unbind" do
    %w(post_init receive_data unbind).each do |meth|
      @handler.should respond_to(meth)
    end
  end
  
  it "should prompt text with a newline before" do
    @handler.should_receive(:send_data).with("\nFoo")
    @handler.prompt("Foo")
  end
  
  it "should display text with a newline before & after" do
    @handler.should_receive(:send_data).with("\nFoo Data\n")
    @handler.display("Foo Data")
  end
  
  it "should use the Connector to handle input data if no player is logged in" do
    @connector = mock("Connector", :logged_in? => false)
    Aeon::Connector.stub!(:new).and_return( @connector )
    @handler.post_init # simulate client connecting
    @connector.should_receive(:handle_input).with("Foo")
    @handler.receive_data("Foo")
  end
  
  it "should send input data to the @player if the player is set" do
    @player = mock("Player")
    @handler.player = @player
    
    @player.should_receive(:handle_input).with("Foo")
    @handler.receive_data("Foo")
  end
  
end