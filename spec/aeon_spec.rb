require File.dirname(__FILE__) + '/spec_helper'

describe "Aeon" do
  it "should insert the lib directory into the load path" do
    $LOAD_PATH.should include(File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib')))
  end
end