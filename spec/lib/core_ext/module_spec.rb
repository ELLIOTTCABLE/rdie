require File.join( File.dirname(__FILE__), "..", "..", "spec_helper" )

module ModuleSpecHelper
end
describe 'Core extensions:' do
  describe Module do
    it { Module.should respond_to(:attr_default) }

    it "should raise if not passed a block to attr_default" do
      lambda {
        module ModuleSpecHelper
          attr_default(:hit_points)
        end
      }.should raise_error(ArgumentError, /default value in block required/i)
    end
  
    describe "(with a default attribute)" do
      include ModuleSpecHelper
    
      before do
        module ModuleSpecHelper
          attr_default(:hit_points) { 10 }
        end
      end
    
      after do
        module ModuleSpecHelper
          undef_method(:hit_points, :hit_points=)
        end
      end
    
      it "should have #hit_points= and #hit_points defined" do
        ModuleSpecHelper.instance_methods.should include("hit_points=", "hit_points")
      end
    
      it "should have 10 hit points by default" do
        hit_points.should == 10
      end
    
      it "should return the set hit points after using the writer method" do
        self.hit_points = 15
        hit_points.should == 15
      end
    end
  end
end