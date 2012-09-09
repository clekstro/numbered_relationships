class DramaticMoment < ActiveRecord::Base
  attr_accessible :artistic_pause_id, :duration
  belongs_to :artistic_pause
end
