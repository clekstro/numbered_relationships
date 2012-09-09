class ArtisticPause < ActiveRecord::Base
  attr_accessible :duration, :performance_id
  belongs_to :performance
end
