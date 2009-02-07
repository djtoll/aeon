require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::VisualEvent do
  it "should display messages" do
    char1 = mock("character1")
    char2 = mock("character2")
    char3 = mock("character3")
    room  = mock("room", :objects => [char1, char2, char3])
    
    char1.should_receive(:display).with("You has a lulz!")
    [char2, char3].each {|c| c.should_receive(:display).with("Ethrin lulz.")}
    
    Aeon::VisualEvent.new :instigator => char1,
                          :target     => room,
                          :message    => "Ethrin lulz.",
                          :to_self    => "You has a lulz!"   
  end
  
  
end