shared_examples_for "an instance-based through association filter" do
  let(:instance){ FactoryGirl.create(:jester, name: 'Joker') }
  let(:repertoire) { Repertoire.create! }
  let(:first_performance) { Performance.create(name: 'First Performance') }
  let(:first_pause) { ArtisticPause.create(duration: 10, performance_id: first_performance.id)}
  let(:last_performance) { Performance.create(name: 'Last Performance') }
  # before(:each) do

  # end
  # Params:       klass, primary_association, primary_factory, secondary_association, secondary_factory
  # Sample call: Jester, :repertoire, :performances,      :performance
  before(:each) do
    instance.repertoire = repertoire
    instance.repertoire.performances << [first_performance, last_performance]
  end
  context ": #with_at_least" do
    it "shows no results if lower bound not met" do
      instance.performances.with_at_least(1, :dramatic_moments).should == []
    end
    it "shows results at and above lower bound" do
      DramaticMoment.create(duration:2, artistic_pause_id: first_pause)
      instance.performances.with_at_least(1, :dramatic_moments).should include(first_performance)
      DramaticMoment.create(duration:2, artistic_pause_id: first_pause)
      instance.performances.with_at_least(1, :dramatic_moments).should include(first_performance)
    end
  end
  # context "with_at_most" do
  #   it "responds with empty array when no has_many objects" do
  #     eval("instance.#{primary_association.to_s}.with_at_most(1, secondary_association)").should == []
  #   end
  #   before(:each) do
  #     j1 = FactoryGirl.create(primary_factory)
  #     j2 = FactoryGirl.create(primary_factory)
  #     eval("instance.#{primary_association.to_s} << [j1, j2]")
  #   end
  #   it "shows no results if higher than upper bound" do
  #     j1 = FactoryGirl.create(primary_factory)
  #     l1 = FactoryGirl.create(secondary_factory)
  #     l2 = FactoryGirl.create(secondary_factory)
  #     eval("j1.#{secondary_association.to_s} << [l1, l2]")
  #     eval("instance.#{primary_association.to_s} << j1")
  #     eval("instance.#{primary_association.to_s}.with_at_most(1, secondary_association)").should == []
  #   end
  #   it "shows results at upper bound" do
  #     j1 = FactoryGirl.create(primary_factory)
  #     l1 = FactoryGirl.create(secondary_factory)
  #     eval("j1.#{secondary_association.to_s} << [l1]")
  #     eval("instance.#{primary_association.to_s} << j1")
  #     eval("instance.#{primary_association.to_s}.with_at_most(1, secondary_association)").should include(j1)
  #   end
  #   it "shows results below upper bound" do
  #     j1 = FactoryGirl.create(primary_factory)
  #     l1 = FactoryGirl.create(secondary_factory)
  #     l2 = FactoryGirl.create(secondary_factory)
  #     eval("j1.#{secondary_association.to_s} << [l1, l2]")
  #     eval("instance.#{primary_association.to_s} << j1")
  #     eval("instance.#{primary_association.to_s}.with_at_most(3, secondary_association)").should include(j1)
  #   end
  # end
  # context "#with_exactly" do
  #   it "responds with empty array when no has_many objects" do
  #     eval("instance.#{primary_association.to_s}.with_at_most(1, secondary_association)").should == []
  #   end
  #   it "shows results when exactly n #{secondary_association} present" do
  #     j1 = FactoryGirl.create(primary_factory)
  #     l1 = FactoryGirl.create(secondary_factory)
  #     eval("j1.#{secondary_association.to_s} << [l1]")
  #     eval("instance.#{primary_association.to_s} << j1")
  #     eval("instance.#{primary_association.to_s}.with_exactly(1, secondary_association)").should include(j1)
  #   end
  #   it "shows no results when only more or less than n #{secondary_association}" do
  #     j1 = FactoryGirl.create(primary_factory)
  #     l1 = FactoryGirl.create(secondary_factory)
  #     eval("j1.#{secondary_association.to_s} << [l1]")
  #     eval("instance.#{primary_association.to_s} << j1")
  #     eval("instance.#{primary_association.to_s}.with_exactly(0, secondary_association)").should == []
  #     eval("instance.#{primary_association.to_s}.with_exactly(2, secondary_association)").should == []
  #   end
  # end
  # context "#without" do
  #   it "return objects with non n primary_factory counts (+/-) and none with n" do
  #     j1 = FactoryGirl.create(primary_factory)
  #     l1 = FactoryGirl.create(secondary_factory)
  #     eval("j1.#{secondary_association.to_s} << [l1]")
  #     eval("instance.#{primary_association.to_s} << j1")
  #     eval("instance.#{primary_association.to_s}.without(2, secondary_association)").should == [j1]
  #     eval("instance.#{primary_association.to_s}.without(1, secondary_association)").should == []
  #     l2 = FactoryGirl.create(secondary_factory)
  #     l3 = FactoryGirl.create(secondary_factory)
  #     eval("j1.#{secondary_association.to_s} << [l2, l3]")
  #     eval("instance.#{primary_association.to_s}.without(2, secondary_association)").should == [j1]
  #   end
  # end
  # context "#with_more_than" do
  #   it "not return objects with less than or equal to n jokes" do
  #     j1 = FactoryGirl.create(primary_factory)
  #     l1 = FactoryGirl.create(secondary_factory)
  #     eval("instance.#{primary_association.to_s}.with_more_than(1, secondary_association)").should == []
  #     eval("j1.#{secondary_association.to_s} << [l1]")
  #     eval("instance.#{primary_association.to_s} << j1")
  #     eval("instance.#{primary_association.to_s}.with_more_than(1, secondary_association)").should == []
  #   end
  #   it "return objects with more than n jokes" do
  #     j1 = FactoryGirl.create(primary_factory)
  #     l1 = FactoryGirl.create(secondary_factory)
  #     eval("j1.#{secondary_association.to_s} << [l1]")
  #     eval("instance.#{primary_association.to_s} << j1")
  #     eval("instance.#{primary_association.to_s}.with_more_than(0, secondary_association)").should == [j1]
  #   end
  # end
  # context "with_less_than" do
  #   it "not return objects with more than or having n jokes" do
  #     j1 = FactoryGirl.create(primary_factory)
  #     l1 = FactoryGirl.create(secondary_factory)
  #     eval("j1.#{secondary_association.to_s} << [l1]")
  #     eval("instance.#{primary_association.to_s} << j1")
  #     eval("instance.#{primary_association.to_s}.with_less_than(1, secondary_association)").should == []
  #     l2 = FactoryGirl.create(secondary_factory)
  #     eval("j1.#{secondary_association.to_s} << [l2]")
  #     eval("instance.#{primary_association.to_s}.with_less_than(1, secondary_association)").should == []
  #   end
  #   it "return objects with less than n jokes" do
  #     j1 = FactoryGirl.create(primary_factory)
  #     l1 = FactoryGirl.create(secondary_factory)
  #     eval("j1.#{secondary_association.to_s} << [l1]")
  #     eval("instance.#{primary_association.to_s} << j1")
  #     eval("instance.#{primary_association.to_s}.with_less_than(2, secondary_association)").should == [j1]
  #   end
  # end
end
