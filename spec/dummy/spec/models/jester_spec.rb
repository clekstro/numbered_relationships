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
      it "should correctly filter on joke count" do
        j1 = FactoryGirl.create(:joke)
        j2 = FactoryGirl.create(:joke)
        Jester.with_at_least(1, :jokes).should_not include(funny_jester)
        funny_jester.jokes << j1
        Jester.with_at_least(1, :jokes).should include(funny_jester)
        funny_jester.jokes << j2
        Jester.with_at_least(1, :jokes).should include(funny_jester)
      end
    end
    context "with_at_most" do

    end
    context "with_exactly" do

    end
    context "without" do

    end
    context "with_more_than" do

    end
    context "with_less_than" do

    end
  end
  describe "habtm" do
    context
  end

end
