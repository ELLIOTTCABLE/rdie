# This is our totally sick and badass die rolling class. It uses rand() right
# now, but another tool could be substituted (with a more powerful RNG). Any
# mathematical methods called on a Die object of this class are then stored,
# and later applied when the die is rolled:
#     my_die = (D[6] + 1) / 2
#     my_die.roll # => 9
#     my_die.roll # => 7
class D
  def initialize(die)
    @modifiers = []
    @die = die
    raise 'Die must be a Fixnum' unless @die.class == Fixnum
  end
  
  # This creates a new die object
  def self.[] die
    case die
    when 00
      new 100
    else
      new die
    end
  end
  
  def roll
    value = r @die
    @modifiers.each do |method, args|
      value = value.send(method, *args)
    end
    value
  end
  
  # Here, we grab and store incoming methods that could possibly be run on the
  # resultant value of the die roll.
  def method_missing(method, *args)
    raise NoMethodError,
      "Neither #{self.inspect} nor Fixnum objects respond to #{method(method).inspect}." unless
        1.respond_to? method
    
    @modifiers << [method, args]
    self
  end
  
  private
  # Use #r to actually roll the die, it calls this (as well as applying stored
  # modifer methods).
  def r die
    rand(die) + 1
  end
end