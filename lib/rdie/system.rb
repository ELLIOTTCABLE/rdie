module RDie::System
  require 'lib/classist'
  require 'rdie/system/classhook'

  def self.included(nnodule)
    nnodule.module_eval do
      include Classist
      
      def self.classize(klass)
        klass.extend RDie::System::ClassHook
      end
    end
  end
end