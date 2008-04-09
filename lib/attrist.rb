class Module
  alias_method :__public__, :public
  alias_method :__private__, :private
  alias_method :__protected__, :protected

  def public(*args)
    if args.empty?
      @__access__ = :public
      __public__
    else
      __public__(*args)
    end
  end
  
  def private(*args)
    if args.empty?
      @__access__ = :private
      __private__
    else
      __private__(*args)
    end
  end

  def protected(*args)
    if args.empty?
      @__access__ = :protected
      __protected__
    else
      __protected__(*args)
    end
  end
end

module Attrist
  # Wow, over-complicate much?
  def create_accessor(*input_values)
    arguments = {:reader => true, :writer => true}
    attributes = {}
    
    input_values.each do |input|
      attributes = case input
      when Symbol || String
        attributes.merge Hash[input, nil]
      when Hash
        attributes.merge input
      else
        raise ArgumentError, "can't accept #{input.class.inspect}"
      end
    end
    
    attributes.each do |attribute, value|
      attribute_ivar = '@' + attribute.to_s
      reader = attribute.to_sym
      writer = (attribute.to_s + '=').to_sym
      
      module_eval {
        define_method(reader) do
          if instance_variables.include? attribute_ivar
            instance_variable_get(attribute_ivar)
          else
            instance_variable_set(attribute_ivar, value)
          end
        end
      } if arguments[:reader]
      
      module_eval {
        define_method(writer) do |new_value|
          instance_variable_set(attribute_ivar, new_value)
        end
      } if arguments[:writer]
      
    end
  end
  
  def publicize_attr attribute
    reader = attribute.to_sym
    writer = (attribute.to_s + '=').to_sym
    send(:public, reader) if method_defined? reader
    send(:public, writer) if method_defined? writer
  end
  
  def protect_attr attribute
    reader = attribute.to_sym
    writer = (attribute.to_s + '=').to_sym
    send(:protected, reader) if method_defined? reader
    send(:protected, writer) if method_defined? writer
  end
  
  def privatize_attr attribute
    reader = attribute.to_sym
    writer = (attribute.to_s + '=').to_sym
    send(:private, reader) if method_defined? reader
    send(:private, writer) if method_defined? writer
  end

  @__access__ = :public # Let's be nice and explicit.
end