class Joke < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :jester
end
