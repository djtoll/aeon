require File.dirname(__FILE__) + '/../spec_helper'

describe Commandable do
  
  # Setting up the example class up front kinda sucks, but I had trouble
  # figuring out how to do it in isolation within each test.
  class CommandableThing
    include Commandable
    
    command :foo do
      "bar"
    end
    
    command :foo_arg do |arg|
      arg
    end
    
    command :look    do; end
    command :looktwo do; end
  end
  
  
  before(:each) do
    @thing = CommandableThing.new
  end
  
  it "should define commands" do
    @thing.should respond_to(:cmd_foo)
    @thing.cmd_foo.should == "bar"
  end
  
  it "should define commands that take arguments" do
    @thing = CommandableThing.new
    @thing.cmd_foo_arg('hi').should == 'hi'
  end
  
  it "should allow abbreviated commands based on the order in which they were defined" do  
    @thing.should_receive(:cmd_look)
    @thing.execute_command('l')
  end
  
end
