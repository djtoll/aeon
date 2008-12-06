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

      # puts "r1.east = #{r1.east}"
      # puts "r2.west = #{r2.west}"

      @r1.east.should == @r2
      @r2.west.should == @r1
    end

    it "should link one Room to another and destroy the existing link" do
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
    
    it "should not allow room1 to link to room2 if room1 already links to room2 in some other direction" do
      @r1.link(:east, @r2)
      # lambda { @r1.link(:north, @r2) }.should raise_error
      @r1.link(:north, @r2)
    end
  end

end