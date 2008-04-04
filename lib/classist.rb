module Classist
  ##
  # When included into a module or class Foo, this will cause any classes defined
  # within Foo to run the method Foo.classize(the_new_class). This module is
  # no more than a sort of placeholder, all the real magic happens in
  # Object.inherited.
  # TODO: Figure out a way to do this, without messing with Object
end

class Object
  def self.inherited(klass)
    ancestors = klass.name.split('::')
    
    ancestors = ancestors.inject([Object.send(:const_get, ancestors.first)]) do |acc, ancestor|
      acc << acc.last.send(:const_get, ancestor)
    end
    
    classies = ancestors.reject{|a| !a.include? Classist}
    classies.each do |classy|
      classy.class_eval do
        classize(klass)
      end
    end
  end
end