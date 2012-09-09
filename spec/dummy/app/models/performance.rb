class Performance < ActiveRecord::Base
  attr_accessible :name
  belongs_to :repertoire
  has_many :artistic_pauses
  has_many :dramatic_moments, :through => :artistic_pauses
end
