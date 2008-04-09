require 'rdie/system/attributehooks'

module RDie::System::ClassHook
  include RDie::System::AttributeHooks
  # Anything in this module will become a class method on any class defined in
  #   a module including RDie::System.
end