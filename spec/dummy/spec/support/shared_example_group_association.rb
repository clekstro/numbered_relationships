shared_examples_for "a class based association filter" do |klass, association_type, factory_name|
  let(:instance_with_more){ FactoryGirl.create(klass.name.downcase.to_sym) }
  let(:instance_with_less){ FactoryGirl.create(klass.name.downcase.to_sym) }
  context "with_at_least" do
    it "should respond with empty array when no has_many objects" do
      klass.with_at_least(1, association_type).should == []
    end
    it "should not show any results if lower bound not met" do
      klass.with_at_least(1, association_type).should_not include(instance_with_more)
    end
    it "should show results at lower bound" do
      j1 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{association_type.to_s} << j1")
      klass.with_at_least(1, association_type).should include(instance_with_more)
    end
    it "should show results above lower bound" do
      j2 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{association_type.to_s} << j2")
      klass.with_at_least(1, association_type).should include(instance_with_more)
    end
  end
  context "with_at_most" do
    it "should respond with empty array when no has_many objects" do
      klass.with_at_most(1, association_type).should == []
    end
    before(:each) do
      j1 = FactoryGirl.create(factory_name)
      j2 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{association_type.to_s} << [j1, j2]")
    end
    it "should not show any results if higher than upper bound" do
      klass.with_at_most(1, association_type).should_not include(instance_with_more)
    end
    it "should show results at upper bound" do
      klass.with_at_most(2, association_type).should include(instance_with_more)
    end
    it "should show results below upper bound" do
      klass.with_at_most(3, association_type).should include(instance_with_more)
    end
  end
  context "with_exactly" do
    it "should respond with empty array when no has_many objects" do
      klass.with_exactly(1, association_type).should == []
    end
    it "should show results with exactly n jokes" do
      j1 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{association_type.to_s} << j1")
      klass.with_exactly(1, association_type).should include(instance_with_more)
    end
    it "should not show jesters with more or less than n" do
      klass.with_exactly(1, association_type).should_not include(instance_with_less)
      j1 = FactoryGirl.create(factory_name)
      j2 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{association_type.to_s} << [j1, j2]")
      klass.with_exactly(1, association_type).should_not include(instance_with_more)
    end
  end
  context "without" do
    it "should not return objects with n jokes" do
      klass.without(0, association_type).should_not include(instance_with_more, instance_with_less)
    end
    it "should return objects with non n factory_name counts" do
      j1 = FactoryGirl.create(factory_name)
      j2 = FactoryGirl.create(factory_name)
      j3 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{association_type.to_s} << [j1, j2, j3]")
      j4 = FactoryGirl.create(factory_name)
      eval("instance_with_less.#{association_type.to_s} << j4")
      klass.without(2, association_type).should include(instance_with_more, instance_with_less)
    end
  end
  context "with_more_than" do
    it "should not return objects with less than or equal to n jokes" do
      klass.with_more_than(0, association_type).should_not include(instance_with_more, instance_with_less)
      j1 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{association_type.to_s} << j1")
      klass.with_more_than(1, association_type).should_not include(instance_with_more, instance_with_less)
    end
    it "should return objects with more than n jokes" do
      j1 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{association_type.to_s} << j1")
      klass.with_more_than(0, association_type).should include(instance_with_more)
    end
  end
  context "with_less_than" do
    it "should not return objects with more than or having n jokes" do
      klass.with_less_than(0, association_type).should_not include(instance_with_more, instance_with_less)
      j1 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{association_type.to_s} << j1")
      klass.with_less_than(1, association_type).should_not include(instance_with_more, instance_with_less)
    end
    it "should return objects with less than n jokes" do
      j1 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{association_type.to_s} << j1")
      klass.with_less_than(2, association_type).should include(instance_with_more)
    end
  end
end
