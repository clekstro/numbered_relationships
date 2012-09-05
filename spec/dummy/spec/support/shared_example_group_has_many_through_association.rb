shared_examples_for "a class based through association filter" do |klass, thru_model, association_type, factory_name|
  #klass, thru_model, association_type, factory_name
  #Jester, :repertoire, :performances, :performance
  let(:instance_with_more){ FactoryGirl.create(klass.name.downcase.to_sym) }
  context "with_at_least" do
    it "should respond with empty array when no has_many objects" do
      klass.with_at_least(1, association_type).should == []
    end
    it "should not show any results if lower bound not met" do
      klass.with_at_least(1, association_type).should_not include(instance_with_more)
    end
    it "should show results at and above lower bound" do
      j1 = thru_model.to_s.classify.constantize.create!
      k1 = FactoryGirl.create(factory_name)
      k2 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{thru_model.to_s} = j1")
      eval("instance_with_more.#{thru_model.to_s}.#{association_type.to_s} << k1")
      klass.with_at_least(1, association_type).should include(instance_with_more)
      eval("instance_with_more.#{thru_model.to_s}.#{association_type.to_s} << k2")
      klass.with_at_least(1, association_type).should include(instance_with_more)
    end
  end
  context "with_at_most" do
    it "should respond with empty array when no has_many objects" do
      klass.with_at_most(1, association_type).should == []
    end
    it "should not show any results if higher than upper bound" do
      j1 = thru_model.to_s.classify.constantize.create!
      k1 = FactoryGirl.create(factory_name)
      k2 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{thru_model.to_s} = j1")
      eval("instance_with_more.#{thru_model.to_s}.#{association_type.to_s} << [k1,k2]")
      klass.with_at_most(1, association_type).should_not include(instance_with_more)
    end
    it "should show results at upper bound" do
      j1 = thru_model.to_s.classify.constantize.create!
      k1 = FactoryGirl.create(factory_name)
      k2 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{thru_model.to_s} = j1")
      eval("instance_with_more.#{thru_model.to_s}.#{association_type.to_s} << [k1,k2]")
      klass.with_at_most(2, association_type).should include(instance_with_more)
    end
    it "should show results below upper bound" do
      j1 = thru_model.to_s.classify.constantize.create!
      k1 = FactoryGirl.create(factory_name)
      k2 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{thru_model.to_s} = j1")
      eval("instance_with_more.#{thru_model.to_s}.#{association_type.to_s} << [k1,k2]")
      klass.with_at_most(3, association_type).should include(instance_with_more)
    end
  end
  context "with_exactly" do
    it "should respond with empty array when no has_many objects" do
      klass.with_exactly(1, association_type).should == []
    end
    it "should not show jesters with more or less than n" do
      j1 = thru_model.to_s.classify.constantize.create!
      k1 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{thru_model.to_s} = j1")
      eval("instance_with_more.#{thru_model.to_s}.#{association_type.to_s} << [k1]")
      klass.with_exactly(0, association_type).should_not include(instance_with_more)
      k2 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{thru_model.to_s}.#{association_type.to_s} << [k2]")
      klass.with_exactly(1, association_type).should_not include(instance_with_more)
    end
    it "should show results with exactly n jokes" do
      j1 = thru_model.to_s.classify.constantize.create!
      k1 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{thru_model.to_s} = j1")
      eval("instance_with_more.#{thru_model.to_s}.#{association_type.to_s} << [k1]")
      klass.with_exactly(1, association_type).should include(instance_with_more)
    end
  end
  context "without" do
    it "should not return objects with n" do
      klass.without(1, association_type).should_not include(instance_with_more)
    end
    it "should return objects with non n amounts" do
      j1 = thru_model.to_s.classify.constantize.create!
      k1 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{thru_model.to_s} = j1")
      eval("instance_with_more.#{thru_model.to_s}.#{association_type.to_s} << [k1]")
      klass.without(2, association_type).should include(instance_with_more)
      k2 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{thru_model.to_s}.#{association_type.to_s} << [k2]")
      klass.without(1, association_type).should include(instance_with_more)
    end
  end
  context "with_more_than" do
    it "should not return objects with less than or equal to n jokes" do
      j1 = thru_model.to_s.classify.constantize.create!
      k1 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{thru_model.to_s} = j1")
      eval("instance_with_more.#{thru_model.to_s}.#{association_type.to_s} << [k1]")
      klass.with_more_than(1,association_type).should_not include(instance_with_more)
      k2 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{thru_model.to_s}.#{association_type.to_s} << [k2]")
      klass.with_more_than(2, association_type).should_not include(instance_with_more)
    end
    it "should return objects with more than n jokes" do
      j1 = thru_model.to_s.classify.constantize.create!
      k1 = FactoryGirl.create(factory_name)
      k2 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{thru_model.to_s} = j1")
      eval("instance_with_more.#{thru_model.to_s}.#{association_type.to_s} << [k1,k2]")
      klass.with_more_than(1,association_type).should include(instance_with_more)
    end
  end
  # context "with_less_than" do
  #   it "should not return objects with more than or having n jokes" do
  #     klass.with_less_than(0, association_type).should_not include(instance_with_more, instance_with_less)
  #     j1 = FactoryGirl.create(factory_name)
  #     eval("instance_with_more.#{thru_model.to_s}.#{association_type.to_s} << j1")
  #     klass.with_less_than(1, association_type).should_not include(instance_with_more, instance_with_less)
  #   end
  #   it "should return objects with less than n jokes" do
  #     j1 = FactoryGirl.create(factory_name)
  #     eval("instance_with_more.#{thru_model.to_s}.#{association_type.to_s} << j1")
  #     klass.with_less_than(2, association_type).should include(instance_with_more)
  #   end
  # end
end
