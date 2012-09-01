require_relative '../spec_helper'
require_relative '../../app/models/jester'

describe Jester do
	let(:funny_jester){ FactoryGirl.create(:jester) }
	let(:lame_jester){ FactoryGirl.create(:jester) }
  context "with_at_least" do
    it{ should respond_to(:with_at_least) }
    it "should respond with empty array when no has_many objects" do
      Jester.with_at_least(1, :jokes).should == []
    end
  end
  context "with_at_most" do
    it{ should respond_to(:with_at_most) }
  end
  context "with_exactly" do
    it{ should respond_to(:with_exactly) }
  end
  context "without" do
    it{ should respond_to(:without) }
  end
  context "with_more_than" do
    it{ should respond_to(:with_more_than) }
  end
  context "with_less_than" do
    it{ should respond_to(:with_less_than) }
  end
end
