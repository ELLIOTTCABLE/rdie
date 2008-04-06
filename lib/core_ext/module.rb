class Module
  # By Gregor Schmidt, see <http://www.nach-vorne.de/2007/4/24/attr_accessor-on-steroids>
  def attr_default( *syms, &block )
    raise ArgumentError, 'Default value in block required' unless block
    syms.each do | sym |
      module_eval do
        attr_writer( sym )
        define_method( sym ) do | |
          class << self; self; end.class_eval do
            attr_reader( sym )
          end
          if instance_variables.include? "@#{sym}"
            instance_variable_get( "@#{sym}" )
          else
            instance_variable_set( "@#{sym}", block.call )
          end
        end
      end
    end
    nil
  end
end