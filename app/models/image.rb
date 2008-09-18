#

class Image < ActiveRecord::Base
  has_many :findings, :order => :created_at
end
