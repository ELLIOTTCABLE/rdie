require File.join( File.dirname(__FILE__), "..", "spec_helper" )
require 'd'

describe D do
  
  it "should be able to roll standard RPG gaming die" do
    [4, 6, 8, 10, 12, 20].each do |die|
      values = get_rolls D[die]
      values.each do |value|
        value.should be <= die
        value.should be >= 1
      end
    end
  end
  
  it "should be able to roll d00, i.e. d100" do
    values = get_rolls D[00]
    values.each do |value|
      value.should be <= 100
      value.should be >= 1
    end
  end
  
  it "should be able to do basic die math" do
    values = get_rolls D[6] * 2
    values.each do |value|
      (value % 2).should be_zero
      value.should be <= 12
      value.should be >= 2
    end
  end
  
  it "should explode if you send a non-mathematical method to a die" do
    lambda { D[6].wtf }.should raise_error(NoMethodError,
      /undefined method ‘wtf’ for /)
  end
  
  it "should be min-able" do
    mind_values = get_rolls D[10].min(3)
    mind_values.each do |value|
      value.should be <= 10
      value.should be >= 3
    end
  end
  
  it "should be max-able" do
    maxd_values = get_rolls D[10].max(7)
    maxd_values.each do |value|
      value.should be <= 7
      value.should be >= 1
    end
  end
  
  it "should accept chaining of arbitrary methods" do
    die = D[6].chain :wtf, 'an argument'
    die.chained.should == [[:wtf, ['an argument']]]
    lambda { die.roll }.should raise_error(NoMethodError,
      /undefined method .wtf. for /)
  end
  
  # This rolls a D die 250 times, and pushes the unique values into an array.
  def get_rolls die
    (1..250).inject([]) {|array, _| array << die.roll}.uniq
  end
end