require 'rdie'

# This is an example system to exhibit system creation. To 'play' the game,
# use the following in `merb -i`:
#     require 'example_game'
# 
#     elliott = ExampleGame::Character.new
#     puts elliott.hp
# 
#     moose = ExampleGame::Creature.new
#     puts moose.hp
# 
#     longsword = ExampleGame::Sword.new
# 
#     elliott.equip longsword
#     puts elliott.equipped
# 
#     elliott.attack moose
#     puts elliott.hp
#     puts moose.hp
module ExampleGame
  include RDie::System
  
  # You can put more global methods here, that might be useful across the
  # project.
end

class ExampleGame::TargetError < ArgumentError; end

class ExampleGame::Encounter
  def initialize(*creatures)
    raise ArgumentError, 'You must have at least two Creatures for an Encounter' unless
      creatures.size >= 2
      
    creatures.each do |creature|
      raise ArgumentError, 'Only Creatures can be involved in an Encounter' unless
        creature.class.ancestors.include? ExampleGame::Creature
    end
    
    involved = creatures.inject Hash.new do |hash, creature|
      initiative = D[20].roll + creature.initiative
      
      until !hash[initiative]
        initiative = D[20].roll + creature.initiative
      end
      
      hash[initiative] = creature
      hash
    end
    
    @involved = involved.keys.sort.inject([]) { |acc,k| acc << involved[k] }
  end
  
  attr_accessor :involved
end

# --- -- --- -- --- -- --- -- --- -- --- -- --- -- --- -- --- #

class ExampleGame::Item; end

class ExampleGame::Weapon < ExampleGame::Item
  # We set a default damage for weapons here. It is set ridiculously low,
  # perhaps you could assume an un-typed 'weapon' could be something a
  # character picked up off the ground. Specific weapons can override this
  # variable with something more appropriate.
  # Unlike setting the HP on a new character before, this attribute is a die,
  # and as such, it isn't actually _rolled_ on creation. Methods that
  # reference it should remember to roll it if necessary.
  attr_accessor :damage_die => D[4]
  
  # A character holding this weapon will call Character#attack, which grabs
  # the damage from this method.
  def damage
    damage_die.roll
  end
end

class ExampleGame::Sword < ExampleGame::Weapon
  attr_accessor :damage_die => D[8]
end

# --- -- --- -- --- -- --- -- --- -- --- -- --- -- --- -- --- #

class ExampleGame::Creature
  # attr_default is available to you; it is similar to attr_accessor, except
  # that it takes a block, initializing the instance variables to the return
  # value of the block
  attr_accessor :hp => D[10].roll
  attr_accessor :equipped
  attr_accessor :initiative => 0
  
  # Methods work exactly as in normal ruby; normal methods will be available
  # to players and their scripts, private methods are not - mark methods as
  # private when they are just programmatic seperations of code to be executed
  # and leave them public when it's something the class of object actually
  # should be able to 'DO' in the game environment.
  
  # This is public, because a creature should be able to 'attack' something
  # in-game.
  def attack target
    check_target_validity_of target
    
    # In this particular case, we simply proxy to the #__attack__ method.
    __attack__(target)
  end
  
  private
  
  # This is private, because it's only important for other methods within this
  # class to use; Creatures can't actually check the validity as a target of
  # another object in-game.
  def check_target_validity_of target
    raise ExampleGame::TargetError unless
      target.class.ancestors.include? ExampleGame::Creature
    
    target
  end
  
  # Same here - you can't attack with a weapon that isn't equipped, so #attack
  # takes care of passing in the weapon. Then, this method actually does the
  # heavy lifting, checking the weapon's damage, and removing hitpoints from
  # the target.
  # 
  # Unlike #check_target_validity_of, #attack is something you could
  # actually do in game; it's a private method, because we don't want people
  # using this to do so. You would achieve the same effect by first using 
  # the #equip method with the weapon you want to attack with, and then using
  # the standard #attack method.
  def __attack__(target)
    raise 'No weapon equipped' unless
      equipped.class.ancestors.include? ExampleGame::Weapon
    
    target.hp -= equipped.damage
    target
  end
  
  public
  
  def equip item
    raise ArgumentError unless
      item.class.ancestors.include? ExampleGame::Item
    
    self.equipped = item
  end
  
  def unequip
    self.equipped = nil
  end
end

class ExampleGame::Character < ExampleGame::Creature
  attr_accessor :hp => D[12].roll # That's right, player characters are
                                  # stronger than most!
end