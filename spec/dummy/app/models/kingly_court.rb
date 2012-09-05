class KinglyCourt < ActiveRecord::Base
  # attr_accessible :title, :body
  has_and_belongs_to_many :jesters
  has_and_belongs_to_many :performances
end
