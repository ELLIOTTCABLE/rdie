module RDie::System
  require 'lib/classist'
  require 'rdie/system/classhook'

  def self.included(nnodule)
    nnodule.module_eval do
      
      include Classist
      
      def self.classize(klass)
        klass.extend RDie::System::ClassHook
        
        klass.class_eval do
          self.send(:remove_const, :S) if const_defined? :S
          self.send(:const_set, :S, self)
        end
      end
      
      acquire File.join('systems', self.name.split('::').last.downcase)
    end
  end
end