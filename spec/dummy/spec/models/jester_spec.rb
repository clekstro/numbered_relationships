require_relative '../spec_helper'
require_relative '../../app/models/jester'

describe Jester do

  subject { Jester }
  it{ should respond_to(:with_at_least) }
  it{ should respond_to(:with_at_most) }
  it{ should respond_to(:with_exactly) }
  it{ should respond_to(:without) }
  it{ should respond_to(:with_more_than) }
  it{ should respond_to(:with_less_than) }

  describe "has_many" do
    let(:funny_jester){ FactoryGirl.create(:jester) }
    let(:lame_jester){ FactoryGirl.create(:jester) }
    context "with_at_least" do
      it "should respond with empty array when no has_many objects" do
        Jester.with_at_least(1, :jokes).should == []
      end
      it "should not show any results if lower bound not met" do
        Jester.with_at_least(1, :jokes).should_not include(funny_jester)
      end
      it "should show results at lower bound" do
        j1 = FactoryGirl.create(:joke)
        funny_jester.jokes << j1
        Jester.with_at_least(1, :jokes).should include(funny_jester)
      end
      it "should show results above lower bound" do
        j2 = FactoryGirl.create(:joke)
        funny_jester.jokes << j2
        Jester.with_at_least(1, :jokes).should include(funny_jester)
      end
    end
    context "with_at_most" do
      it "should respond with empty array when no has_many objects" do
        Jester.with_at_most(1, :jokes).should == []
      end
      before(:each) do
      	j1 = FactoryGirl.create(:joke)
        j2 = FactoryGirl.create(:joke)
        funny_jester.jokes << [j1, j2]
      end
      it "should not show any results if higher than upper bound" do
        Jester.with_at_most(1, :jokes).should_not include(funny_jester)
      end
      it "should show results at upper bound" do
        Jester.with_at_most(2, :jokes).should include(funny_jester)
      end
      it "should show results below upper bound" do
        Jester.with_at_most(3, :jokes).should include(funny_jester)
      end
    end
    context "with_exactly" do
    	it "should respond with empty array when no has_many objects" do
        Jester.with_exactly(1, :jokes).should == []
      end
      it "should show results with exactly n jokes" do
      	j1 = FactoryGirl.create(:joke)
        funny_jester.jokes << j1
        Jester.with_exactly(1, :jokes).should include(funny_jester)
      end
      it "should not show jesters with more or less than n" do
        Jester.with_exactly(1, :jokes).should_not include(lame_jester)
        j1 = FactoryGirl.create(:joke)
        j2 = FactoryGirl.create(:joke)
        funny_jester.jokes << [j1, j2]
        Jester.with_exactly(1, :jokes).should_not include(funny_jester)
      end
    end
    context "without" do
    	it "should not return objects with n jokes" do
    	  Jester.without(0, :jokes).should_not include(funny_jester, lame_jester)
    	end
    	it "should return objects with non n joke counts" do
    		j1 = FactoryGirl.create(:joke)
    		j2 = FactoryGirl.create(:joke)
    		j3 = FactoryGirl.create(:joke)
    		funny_jester.jokes << [j1, j2, j3]
    		j4 = FactoryGirl.create(:joke)
    		lame_jester.jokes << j4
    		Jester.without(2, :jokes).should include(funny_jester, lame_jester)
    	end
    end
    context "with_more_than" do
    	it "should not return objects with less than or equal to n jokes" do
    	  Jester.with_more_than(0, :jokes).should_not include(funny_jester, lame_jester)
    	  j1 = FactoryGirl.create(:joke)
    	  funny_jester.jokes << j1
    	  Jester.with_more_than(1, :jokes).should_not include(funny_jester, lame_jester)
    	end
    	it "should return objects with more than n jokes" do
    	  j1 = FactoryGirl.create(:joke)
    	  funny_jester.jokes << j1
    	  Jester.with_more_than(0, :jokes).should include(funny_jester)
    	end
    end
    context "with_less_than" do
    	it "should not return objects with more than or having n jokes" do
    	  Jester.with_less_than(0, :jokes).should_not include(funny_jester, lame_jester)
    	  j1 = FactoryGirl.create(:joke)
    	  funny_jester.jokes << j1
    	 	Jester.with_less_than(1, :jokes).should_not include(funny_jester, lame_jester)
    	end
    	it "should return objects with less than n jokes" do
    	  j1 = FactoryGirl.create(:joke)
    	  funny_jester.jokes << j1
    	  Jester.with_less_than(2, :jokes).should include(funny_jester)
    	end
    end
  end
  describe "habtm" do
    context
  end

end
