require_relative '../spec_helper'

describe Jester do

  subject { Jester }
  it{ should respond_to(:with_at_least) }
  it{ should respond_to(:with_at_most) }
  it{ should respond_to(:with_exactly) }
  it{ should respond_to(:without) }
  it{ should respond_to(:with_more_than) }
  it{ should respond_to(:with_less_than) }
  # Future
  # it{ should respond_to(:with_above_average) }
  # it{ should respond_to(:with_below_average) }

  describe "syntactic sugar" do
    let(:jester) { FactoryGirl.create(:jester) }
    it "should allow use of natural syntax on singular associations" do
      jester.jokes << FactoryGirl.create(:joke)
      Jester.with_at_least(1, :joke).should include(jester)
    end
  end
  describe "chainability: " do
    let(:jester) { FactoryGirl.create(:jester, name: 'J-Man') }
    it "is chainable with other scopes or class methods" do
      jester.jokes << FactoryGirl.create(:joke)
      Jester.with_at_least(1, :joke).where(:name => 'J-Man').should include(jester)
      p1 = FactoryGirl.create(:performance)
      p2 = FactoryGirl.create(:performance)
      rep = Repertoire.create(jester_id: jester)
      jester.repertoire = rep
      jester.repertoire.performances << [p1, p2]
      Jester.funny.experienced.should == [jester]
    end
    it "returns instance of AR::Relation when no match" do
      Jester.with_at_least(1, :joke).where(:name => 'J-Man').should == []
    end
    it "filters on the association when method array specified" do
      jester.jokes << FactoryGirl.create(:joke, funny: true)
      Jester.with_at_least(1, [:below_the_belt], :joke).should == []
      Jester.with_at_least(1, [:dirty], :joke).should include(jester)
    end
  end
  # describe "exceptions" do
  #   it "should throw exception if assocation not present" do
      
  #   end
  # end
  describe "has_many relationship: " do
    it_should_behave_like "a class based association filter", Jester, :jokes, :joke
    it_should_behave_like "an instance-based association filter", Jester, :jokes, :joke, :laughs, :laugh
  end
  describe "has_many, :through: " do
    it_should_behave_like "a class based through association filter", Jester, :repertoire, :performances, :performance
    # performance has_many :dramatic_moments :through => :artistic_pauses
    it_should_behave_like "an instance-based through association filter"
  end
  describe "habtm: " do
    # Jester has and belongs to many kingly courts
  	it_should_behave_like "a class based association filter", Jester, :kingly_courts, :kingly_court
    # Jester instance has and belongs to many kingly courts
    # Kingly courts have and belong to many performances
    it_should_behave_like "an instance-based association filter", Jester, :kingly_courts, :kingly_court, :performances, :performance
  end
end
