class Jester < ActiveRecord::Base
  attr_accessible :name
  has_many :jokes
  has_and_belongs_to_many :kingly_courts
end
