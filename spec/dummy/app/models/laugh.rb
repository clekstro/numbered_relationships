class Laugh < ActiveRecord::Base
  attr_accessible :volume
  belongs_to :joke
end
