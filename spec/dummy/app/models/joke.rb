class Joke < ActiveRecord::Base
  belongs_to :jester
  has_many :laughs
end
