class Jester < ActiveRecord::Base
  attr_accessible :name
  has_many :jokes
end
