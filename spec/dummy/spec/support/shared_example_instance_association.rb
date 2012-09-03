shared_examples_for "an instance-based association filter" do |klass, first_assoc, factory_name, second_assoc, sec_factory|
  let(:instance_with_more){ FactoryGirl.create(klass.name.downcase.to_sym) }
  let(:instance_with_less){ FactoryGirl.create(klass.name.downcase.to_sym) }

  # Params:       klass, first_assoc, factory_name, second_assoc, sec_factory
  # Sample call: Jester, :jokes,      :joke,        :laughs,      :laugh
  context ": #with_at_least" do
    it "responds with empty array when no has_many objects" do
      eval("instance_with_more.#{first_assoc.to_s}.with_at_least(1, second_assoc)").should == []
    end
    # instance.association.with_at_least(2, :another_association)
    it "shows no results if lower bound not met" do
      eval("instance_with_more.#{first_assoc.to_s}.with_at_least(1, second_assoc)").should == []
    end
    it "shows results at lower bound" do
    	# Jester, :kingly_courts, :
      j1 = FactoryGirl.create(factory_name)
      l1 = FactoryGirl.create(sec_factory)
      eval("j1.#{second_assoc.to_s} << l1")
      eval("instance_with_more.#{first_assoc.to_s} << j1")
      # eval("instance_with_more.#{first_assoc.to_s}.create")
      eval("instance_with_more.#{first_assoc.to_s}.with_at_least(1, second_assoc)").should include(j1)
    end
    it "shows results above lower bound" do
      j1 = FactoryGirl.create(factory_name)
      l1 = FactoryGirl.create(sec_factory)
      l2 = FactoryGirl.create(sec_factory)
      eval("j1.#{second_assoc.to_s} << [l1, l2]")
      eval("instance_with_more.#{first_assoc.to_s} << j1")
      eval("instance_with_more.#{first_assoc.to_s}.with_at_least(1, second_assoc)").should include(j1)
    end
  end
  context "with_at_most" do
    it "responds with empty array when no has_many objects" do
      eval("instance_with_more.#{first_assoc.to_s}.with_at_most(1, second_assoc)").should == []
    end
    before(:each) do
      j1 = FactoryGirl.create(factory_name)
      j2 = FactoryGirl.create(factory_name)
      eval("instance_with_more.#{first_assoc.to_s} << [j1, j2]")
    end
    it "shows no results if higher than upper bound" do
      j1 = FactoryGirl.create(factory_name)
      l1 = FactoryGirl.create(sec_factory)
      l2 = FactoryGirl.create(sec_factory)
      eval("j1.#{second_assoc.to_s} << [l1, l2]")
      eval("instance_with_more.#{first_assoc.to_s} << j1")
      eval("instance_with_more.#{first_assoc.to_s}.with_at_most(1, second_assoc)").should == []
    end
    it "shows results at upper bound" do
      j1 = FactoryGirl.create(factory_name)
      l1 = FactoryGirl.create(sec_factory)
      eval("j1.#{second_assoc.to_s} << [l1]")
      eval("instance_with_more.#{first_assoc.to_s} << j1")
      eval("instance_with_more.#{first_assoc.to_s}.with_at_most(1, second_assoc)").should include(j1)
    end
    it "shows results below upper bound" do
      j1 = FactoryGirl.create(factory_name)
      l1 = FactoryGirl.create(sec_factory)
      l2 = FactoryGirl.create(sec_factory)
      eval("j1.#{second_assoc.to_s} << [l1, l2]")
      eval("instance_with_more.#{first_assoc.to_s} << j1")
      eval("instance_with_more.#{first_assoc.to_s}.with_at_most(3, second_assoc)").should include(j1)
    end
  end
  context "#with_exactly" do
    it "responds with empty array when no has_many objects" do
      eval("instance_with_more.#{first_assoc.to_s}.with_at_most(1, second_assoc)").should == []
    end
    it "shows results when exactly n #{second_assoc} present" do
      j1 = FactoryGirl.create(factory_name)
      l1 = FactoryGirl.create(sec_factory)
      eval("j1.#{second_assoc.to_s} << [l1]")
      eval("instance_with_more.#{first_assoc.to_s} << j1")
      eval("instance_with_more.#{first_assoc.to_s}.with_exactly(1, second_assoc)").should include(j1)
    end
    it "shows no results when only more or less than n #{second_assoc}" do
      j1 = FactoryGirl.create(factory_name)
      l1 = FactoryGirl.create(sec_factory)
      eval("j1.#{second_assoc.to_s} << [l1]")
      eval("instance_with_more.#{first_assoc.to_s} << j1")
      eval("instance_with_more.#{first_assoc.to_s}.with_exactly(0, second_assoc)").should == []
      eval("instance_with_more.#{first_assoc.to_s}.with_exactly(2, second_assoc)").should == []
    end
  end
  context "#without" do
    it "return objects with non n factory_name counts (+/-) and none with n" do
      j1 = FactoryGirl.create(factory_name)
      l1 = FactoryGirl.create(sec_factory)
      eval("j1.#{second_assoc.to_s} << [l1]")
      eval("instance_with_more.#{first_assoc.to_s} << j1")
      eval("instance_with_more.#{first_assoc.to_s}.without(2, second_assoc)").should == [j1]
      eval("instance_with_more.#{first_assoc.to_s}.without(1, second_assoc)").should == []
      l2 = FactoryGirl.create(sec_factory)
      l3 = FactoryGirl.create(sec_factory)
      eval("j1.#{second_assoc.to_s} << [l2, l3]")
      eval("instance_with_more.#{first_assoc.to_s}.without(2, second_assoc)").should == [j1]
    end
  end
  context "#with_more_than" do
    it "not return objects with less than or equal to n jokes" do
      j1 = FactoryGirl.create(factory_name)
      l1 = FactoryGirl.create(sec_factory)
      eval("instance_with_more.#{first_assoc.to_s}.with_more_than(1, second_assoc)").should == []
      eval("j1.#{second_assoc.to_s} << [l1]")
      eval("instance_with_more.#{first_assoc.to_s} << j1")
      eval("instance_with_more.#{first_assoc.to_s}.with_more_than(1, second_assoc)").should == []
    end
    it "return objects with more than n jokes" do
      j1 = FactoryGirl.create(factory_name)
      l1 = FactoryGirl.create(sec_factory)
      eval("j1.#{second_assoc.to_s} << [l1]")
      eval("instance_with_more.#{first_assoc.to_s} << j1")
      eval("instance_with_more.#{first_assoc.to_s}.with_more_than(0, second_assoc)").should == [j1]
    end
  end
  # context "with_less_than" do
  #   it "not return objects with more than or having n jokes" do
  #     klass.with_less_than(0, first_assoc).should_not include(instance_with_more, instance_with_less)
  #     j1 = FactoryGirl.create(factory_name)
  #     eval("instance_with_more.#{first_assoc.to_s} << j1")
  #     klass.with_less_than(1, first_assoc).should_not include(instance_with_more, instance_with_less)
  #   end
  #   it "return objects with less than n jokes" do
  #     j1 = FactoryGirl.create(factory_name)
  #     eval("instance_with_more.#{first_assoc.to_s} << j1")
  #     klass.with_less_than(2, first_assoc).should include(instance_with_more)
  #   end
  # end
end
