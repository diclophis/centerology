#

class Image < ActiveRecord::Base
  has_many :findings, :order => :created_at
  validates_presence_of :title
  validates_presence_of :src
  validates_as_uri :src
  #validates_associated :findings
end
