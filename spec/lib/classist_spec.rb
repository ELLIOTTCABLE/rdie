require File.join( File.dirname(__FILE__), "..", "spec_helper" )
require 'classist'

describe Classist do
  before(:all) do
    @spec_helper = lambda do
      module ClassistSpecHelper
        include Classist
        
        Classized = []
        def self.classize(klass)
          Classized << klass
        end
      end
    end
  end
  before(:each) do
    @spec_helper.call
  end
  
  it "should allow the attachment of functionality to syntactically sugary class creation" do
    module ClassistSpecHelper
      class Foo; end
      class Bar; end
    end
    
    ClassistSpecHelper::Classized.should == [
      ClassistSpecHelper::Foo,
      ClassistSpecHelper::Bar]
  end
  
  it "should allow the attachment of functionality to anonymous class creation" do
    # May not be possible, as anonymous methods (by definition) have no name
    # to work with when created, and thus when our hook would be run.
    
    module ClassistSpecHelper
      Foo = Class.new
      Bar = Class.new
    end
    
    # ClassistSpecHelper::Classized.should == [
    #       ClassistSpecHelper::Foo,
    #       ClassistSpecHelper::Bar]
    
    pending
  end
  
  after(:each) do
    Object.send(:remove_const, :ClassistSpecHelper)
  end
end