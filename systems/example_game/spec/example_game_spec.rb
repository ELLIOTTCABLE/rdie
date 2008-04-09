require File.join( File.dirname(__FILE__), "..", "..", "..", "spec", "spec_helper" )
require 'example_game'

describe ExampleGame do
  
  describe ':: Encounter' do
    before(:each) do
      @players = *(1..3).map { ExampleGame::Character.new }
      @enemy = ExampleGame::Creature.new
    end
    
    it "should not allow encounters between less than two creatures" do
      lambda { ExampleGame::Encounter.new(@enemy)
        }.should raise_error(ArgumentError,
        'You must have at least two Creatures for an Encounter')
    end
    
    it "should not allow encounters with anything except creatures" do
      lambda { ExampleGame::Encounter.new(Object.new, *@players)
        }.should raise_error(ArgumentError,
        'Only Creatures can be involved in an Encounter')
    end
    
    # Need to cover lines 44 and 45, not sure how else to do it than this
    it "should have only unique initiative values" do
      100.times { ExampleGame::Encounter.new(@enemy, *@players) }
      pending('Unspec-able')
    end
    
    it "should calculate initiative" do
      encounter = ExampleGame::Encounter.new(@enemy, *@players)
      encounter.involved.size.should be(4)
      encounter.involved.each do |involvee|
        involvee.class.ancestors.should include ExampleGame::Creature
      end
    end
  end
  
  describe ':: Weapon' do
    before(:each) do
      @weapon = ExampleGame::Weapon.new
    end
    
    it "should roll damage" do
      @weapon.damage.should <= 4
      @weapon.damage.should >= 1
    end
  end
  
  describe ':: Creature' do
    before(:each) do
      @creature = ExampleGame::Creature.new
      @target = ExampleGame::Creature.new
    end
    
    describe '#attack' do
      it "should check the validity of a target before attacking" do
        lambda { @creature.attack Object.new
          }.should raise_error(ExampleGame::TargetError)
      end
      
      it "should check if a weapon is equipped before attempting to attack" do
        lambda { @creature.attack @target
          }.should raise_error('No weapon equipped')
        pending('Needs a specific error type')
      end
      
      it "should reduce the hitpoints on a target" do
        @creature.equip ExampleGame::Sword.new
        @creature.attack @target
        @target.hp.should < 10
      end
    end
    
    describe "#equip" do
      it "should start with nothing equipped" do
        @creature.equipped.should be_nil
      end
      
      it "should be able to equip an item" do
        sword = ExampleGame::Sword.new
        @creature.equip sword
        @creature.equipped.should == sword
      end
      
      it "should only be able to equip Items" do
        lambda { @creature.equip Object.new
          }.should raise_error(ArgumentError)
      end
      
      it "should be able to unequip an item" do
        sword = ExampleGame::Sword.new
        @creature.equip sword
        @creature.unequip
        @creature.equipped.should == nil
      end
    end
  end
  
end