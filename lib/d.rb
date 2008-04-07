# This is our totally sick and badass die rolling class. It uses rand() right
# now, but another tool could be substituted (with a more powerful RNG). Any
# mathematical methods called on a Die object of this class are then stored,
# and later applied when the die is rolled:
#     my_die = (D[6] + 1) / 2
#     my_die.roll # => 9
#     my_die.roll # => 7
class D
  def initialize(die)
    @die = die
    raise 'Die must be a Fixnum' unless @die.class == Fixnum
    
    @max = die
    @min = 1
    
    @modifiers = []
  end
  
  # Instead of doing the standard attr_accessor functioning of #max & #max=, we
  # set both to do the same thing to allow the following syntax:
  #     D[10].min 3
  # This could obviously be achieved with something like `D[7] + 3`, but we
  # define these as well (for the sake of semanticity).
  # Slight difference: #max returns the die object, #max= returns the input
  attr_accessor :maximum
  alias_method :'max=', :'maximum='
  def max(max); @max = max; self; end
  
  # Ditto above, for #min
  attr_accessor :minimum
  alias_method :'min=', :'minimum='
  def min(min); @min = min; self; end
  
  # This creates a new die object
  def self.[] die
    case die
    when 00
      new 100
    else
      new die
    end
  end
  
  # The 'main' method, you call this on a die object to 'roll' it, and return a
  # numeric value you can work with.
  def roll
    roll = r @die
    until (roll <= @max) && (roll >= @min)
      roll = r @die
    end
    @modifiers.each do |method, args|
      roll = roll.send(method, *args)
    end
    roll
  end
  
  # Adds a method to the chain
  def chain method, *args
    @modifiers << [method, args]
    self
  end
  
  # Shows chained methods
  def chained
    @modifiers
  end
  
  private
  # Use #r to actually roll the die, it calls this (as well as applying stored
  # modifer methods).
  def r die
    rand(die) + 1
  end
  
  # Here, we grab and store incoming methods that could possibly be run on the
  # resultant value of the die roll.
  def method_missing(method, *args)
    raise NoMethodError.new("undefined method ‘#{method}’ for #{self.inspect}") unless 1.respond_to? method
    
    @modifiers << [method, args]
    self
  end
end