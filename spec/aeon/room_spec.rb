require File.dirname(__FILE__) + '/../spec_helper'

describe Aeon::Room do

  it "should have east_id, west_id, north_id, south_id" do
    Aeon::Room.properties.collect{|p| p.name}.should include(:east_id, :west_id, :north_id, :south_id)
  end

  describe "rooms on a coordinate plane" do
    before(:each) do
      @r1 = Aeon::Room.new(:name => "r1")
      @r2 = Aeon::Room.new(:name => "r2")
    end

    it "should default a room's coordinates on save" do
      @r1.save
      @r1.geom.should == [0,0,0,0]
    end
    
    it "should figure out geometry on update" do
      @r1.save
      @r1.geom.should == [0,0,0,0]
      @r1.update_attributes(:name => "charlie")
      @r1.geom.should == [0,0,0,0]
      @r1.update_attributes(:x => 1)
      @r1.geom.should == [1,0,0,0]
    end
    
    it "should not allow overlapping rooms" do
      @r1.geom = [0,0]
      @r1.save
      
      @r2.geom = [0,0]
      lambda { @r2.save }.should raise_error
    end
    
    it "should figure out the direction_to a room" do
      @r1.geom = [0,0]
      @r2.geom = [1,0]
      
      @r1.direction_to(@r2).should == :east
      @r2.direction_to(@r1).should == :west
    end
    
    it "should return nil if the direction_to is more than 1 unit apart" do
      @r1.geom = [0,0]
      @r2.geom = [2,0]
      
      @r1.direction_to(@r2).should == nil
      @r2.direction_to(@r1).should == nil
    end
  end
  
  describe "linking rooms together" do
    before(:each) do
      @r1 = Aeon::Room.new(:name => "r1")
      @r2 = Aeon::Room.new(:name => "r2")
    end
    
    it "should raise an error if one or both rooms haven't been saved" do
      lambda { @r1.link(@r2) }.should raise_error
      @r1.save
      lambda { @r1.link(@r2) }.should raise_error
    end
    
    it "should link rooms that are 1 unit apart" do
      @r1.save
      @r2.geom = [-1,0]
      @r2.save
      
      @r1.link(@r2)
      @r1.west_id.should == @r2.id
      @r2.east_id.should == @r1.id
    end

    it "should raise an error if we try to link rooms that are not next to each other and are in the same zone" do
      @r1.save
      @r2.geom = [9,0]
      @r2.save
      
      lambda { @r1.link(@r2) }.should raise_error
    end
    
  end
  
  describe "linking rooms in different zones" do
    before(:each) do
      @r1 = Aeon::Room.new(:name => "r1")
      @r2 = Aeon::Room.new(:name => "r2")
    end
    
    it "should raise if rooms are in the same zone" do
      @r1.save
      @r2.geom = [9,0]
      @r2.save
      
      lambda { @r1.link_zones(@r2) }.should raise_error
    end
    
    it "should link rooms in different zones" do
      @r1.save
      @r2.geom = [9,0,0,2]
      @r2.save
      
      @r1.link_zones(@r2, :north)
      @r1.north_id.should == @r2.id
      @r2.south_id.should == @r1.id
    end
    
    it "should destroy existing links" do
      @r1.save
      @r2.geom = [0,1]
      @r2.save
      
      @r3 = Aeon::Room.create(:name => "r3", :geom => [3,2,0,9])

      @r1.link(@r2)
      @r1.link_zones(@r3, :north)
      
      @r1.north.should == @r3
      @r3.south.should == @r1
      
      @r2.should be_orphaned
      
      @r1.link(@r2)
      @r3.should be_orphaned
      @r1.north.should == @r2
    end
  end  
  
  describe "severing rooms" do
    before(:each) do
      @r1 = Aeon::Room.new(:name => "r1")
      @r2 = Aeon::Room.new(:name => "r2")
    end
    
    it "should sever a link between rooms" do
      @r1.save
      @r2.geom = [1,0]
      @r2.save
      
      @r1.link(@r2)
      @r1.sever(:east)
      
      @r1.should be_orphaned
      @r2.should be_orphaned
    end
  end
  
  describe "exits" do
    before(:each) do
      @r1 = Aeon::Room.create(:name => "r1")
      @r2 = @r1.bulldoze(:north)
      @r3 = @r1.bulldoze(:east)
    end
    
    it "should show exits" do
      @r1.exits.should == [@r2, @r3, nil, nil]
      @r1.exit_list.should == ["n", "e"]
      @r2.exits.should == [nil, nil, @r1, nil]
      @r3.exits.should == [nil, nil, nil, @r1]
    end
    
  end
  
  describe "bulldozing" do

    it "should create a link between the two rooms on bulldoze" do
      r1 = Aeon::Room.create(:name => "r1")

      r1.should_receive(:link)
      new_room = r1.bulldoze(:east)
    end
    
    it "should create a link if the room already exists on the grid" do
      r1 = Aeon::Room.create(:name => "r1")
      r2 = Aeon::Room.create(:name => "r2", :geom => [1,0,0,0])
  
      r1.bulldoze(:east).should == r2
      
      r1.east.should == r2
    end
  end
  
end