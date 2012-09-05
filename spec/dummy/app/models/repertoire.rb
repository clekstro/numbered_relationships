class Repertoire < ActiveRecord::Base
  attr_accessible :jester_id
  belongs_to :jester
  has_many :performances
end
