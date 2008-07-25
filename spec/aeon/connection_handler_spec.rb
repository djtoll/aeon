require File.dirname(__FILE__) + '/../spec_helper'

describe "ConnectionHandler" do
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
  # 
  # it "should prompt" do
  #   @handler.display_prompt("Fozo").should == "\nFoo"
  # end
end