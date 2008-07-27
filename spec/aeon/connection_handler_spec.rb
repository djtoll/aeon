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
    data = "Foo Data"
    @handler.should_receive(:send_data).with("\n#{data}\n")
    @handler.display(data)
  end
end