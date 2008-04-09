require 'attrist'

module RDie::System::AttributeHooks
  include Attrist
  
  def attr_accessor(*args)
    create_accessor(*args)
  end
end