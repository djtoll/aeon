require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::Room do
  
  describe "linking rooms" do
    before(:each) do
      @r1 = Aeon::Room.new(:name => "r1")
      @r2 = Aeon::Room.new(:name => "r2")
      @r3 = Aeon::Room.new(:name => "r3")
      @r4 = Aeon::Room.new(:name => "r4")
    end

    it "should link one Room to another" do
      # @r1 <---------> @r2
      @r1.link(:east, @r2)

      @r1.east.should == @r2
      @r2.west.should == @r1
    end

    it "should link one Room to another and destroy the existing link" do
      # @r1 <---------> @r2
      @r1.link(:east, @r2)
      
      # @r1 <---  xxx > @r2
      #         `.
      #           `---> @r3
      @r1.link(:east, @r3)

      @r1.east.should == @r3
      @r3.west.should == @r1

      @r2.should be_orphaned

      @r1.west.should be_nil
      @r3.east.should be_nil
    end

    it "should do crazy shit" do
      # @r1 <---------> @r2
      # @r3 <---------> @r4
      @r1.link(:east, @r2)
      @r3.link(:east, @r4)

      # @r1 <----  xxx > @r2
      #          `.
      # @r3 < xxx  `---> @r4
      @r1.link(:east, @r4)

      @r1.east.should == @r4
      @r4.west.should == @r1

      @r3.should be_orphaned
      @r2.should be_orphaned
    end
  end

end