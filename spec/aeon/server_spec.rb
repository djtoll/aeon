require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::Server do
  it "should start EventMachine" do
    # at the moment this is the only way I know to test that the server starts
    EventMachine.should_receive(:run)
    Aeon::Server.start
  end
end
