require File.join( File.dirname(__FILE__), "..", "..", "spec_helper" )

describe 'Core extensions:' do
  describe Object do
    it { Object.should respond_to('on_execute') }

    it "should run the on_execute block only if __FILE__ and $0 are the same" do
      $0 = __FILE__ # Unfortunately, I don't know any better way to spec this
      
      on_execute __FILE__ do
        true
      end.should be true
    end
  end
end