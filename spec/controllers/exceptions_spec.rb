require File.join( File.dirname(__FILE__), "..", "spec_helper" )

# I know both of these are absolute crap, but I don't know any better way to
# spec them out. Feel free to actually spec this, starting from scratch.
# Also make sure to re-do them if you actually modify the way exceptions are
# served.
describe Exceptions do
  it "should have a not_found method" do
    dispatch_to(Exceptions, :not_found)
  end

  it "should have a not_acceptable method" do
    dispatch_to(Exceptions, :not_acceptable)
  end
end