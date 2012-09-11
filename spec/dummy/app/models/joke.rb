class Joke < ActiveRecord::Base
  belongs_to :jester
  has_many :laughs

  def self.dirty
  	where(funny: true)
  end

  def self.below_the_belt
  	where(funny: false)
  end

end