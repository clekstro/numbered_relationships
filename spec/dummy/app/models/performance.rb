class Performance < ActiveRecord::Base
  attr_accessible :name
  belongs_to :repertoire
end
