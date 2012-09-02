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

  describe "has_many relationship: " do
    it_should_behave_like "a class based association filter", Jester, :jokes, :joke
    it_should_behave_like "an instance-based association filter", Jester, :jokes, :joke
  end
  describe "habtm" do
  	it_should_behave_like "a class based association filter", Jester, :kingly_courts, :kingly_court
  end
end
