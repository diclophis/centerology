#

class Finding < ActiveRecord::Base
  acts_as_taggable
  belongs_to :person
  belongs_to :image
  validates_presence_of :person
  validates_associated :person
  validates_presence_of :image
  validates_associated :image
end
