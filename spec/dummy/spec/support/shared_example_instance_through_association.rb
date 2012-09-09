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
  context "with_at_most" do
    it "shows no results if higher than upper bound" do
      DramaticMoment.create(duration:2, artistic_pause_id: first_pause)
      DramaticMoment.create(duration:2, artistic_pause_id: first_pause)
      instance.performances.with_at_most(1, :dramatic_moments).should_not include(first_performance)
    end
    it "shows results at and below upper bound" do
      DramaticMoment.create(duration:2, artistic_pause_id: first_pause)
      DramaticMoment.create(duration:2, artistic_pause_id: first_pause)
      instance.performances.with_at_most(2, :dramatic_moments).should include(first_performance)
      instance.performances.with_at_most(3, :dramatic_moments).should include(first_performance)
    end
  end
  context "#with_exactly" do
    it "shows no results when more or less than n" do
      DramaticMoment.create(duration:2, artistic_pause_id: first_pause)
      DramaticMoment.create(duration:2, artistic_pause_id: first_pause)
      instance.performances.with_exactly(1, :dramatic_moments).should_not include(first_performance)
      instance.performances.with_exactly(3, :dramatic_moments).should_not include(first_performance)
    end
    it "shows results when exactly n present" do
      DramaticMoment.create(duration:2, artistic_pause_id: first_pause)
      instance.performances.with_exactly(1, :dramatic_moments).should include(first_performance)
    end

  end
  context "#without" do
    it "shows no results when n" do
      DramaticMoment.create(duration:2, artistic_pause_id: first_pause)
      instance.performances.without(1, :dramatic_moments).should_not include(first_performance)
    end
    it "shows results for more or less than n" do
      DramaticMoment.create(duration:2, artistic_pause_id: first_pause)
      instance.performances.without(2, :dramatic_moments).should include(first_performance)
      DramaticMoment.create(duration:2, artistic_pause_id: first_pause)
      instance.performances.without(1, :dramatic_moments).should include(first_performance)
    end
  end
  context "#with_more_than" do
    it "shows no results when lte n" do
      DramaticMoment.create(duration:2, artistic_pause_id: first_pause)
      instance.performances.with_more_than(1, :dramatic_moments).should_not include(first_performance)
      instance.performances.with_more_than(2, :dramatic_moments).should_not include(first_performance)
    end
    it "shows results when gt n" do
      DramaticMoment.create(duration:2, artistic_pause_id: first_pause)
      DramaticMoment.create(duration:2, artistic_pause_id: first_pause)
      instance.performances.with_more_than(1, :dramatic_moments).should include(first_performance)
    end
  end
  context "with_less_than" do
    it "shows no results when gte n" do
      DramaticMoment.create(duration:2, artistic_pause_id: first_pause)
      instance.performances.with_less_than(1, :dramatic_moments).should_not include(first_performance)
      DramaticMoment.create(duration:2, artistic_pause_id: first_pause)
      instance.performances.with_less_than(1, :dramatic_moments).should_not include(first_performance)
    end
    it "shows results when lt n" do
      DramaticMoment.create(duration:2, artistic_pause_id: first_pause)
      instance.performances.with_less_than(2, :dramatic_moments).should include(first_performance)
    end
  end
end
