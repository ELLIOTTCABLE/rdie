require File.join( File.dirname(__FILE__), "..", "..", "spec_helper" )

describe 'Core extensions:' do
  describe Symbol do
    it { Module.should respond_to('/') }

    it "should be able to join two symbols into a string" do
      (:foo / :bar).should == 'foo/bar'
    end
  
    it "should be able to join a symbol and a string into a string" do
      (:foo / 'bar').should == 'foo/bar'
    end
  
    it "should work the same as String#/ from merb-core" do
      (:foo / 'bar').should == ('foo' / 'bar')
      (:foo / :bar).should == ('foo' / :bar)
    end
  end
end