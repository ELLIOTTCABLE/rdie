require File.join( File.dirname(__FILE__), "..", "..", "..", "spec", "spec_helper" )
require 'example_game'

describe ExampleGame do
  
  describe 'encounter management' do
    it "should calculate initiative" do
      ExampleGame::initiate_encounter
    end
  end
  
end