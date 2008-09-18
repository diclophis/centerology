#

class Person < ActiveRecord::Base
  has_many_friends
  has_many :findings
  has_many :images, :through => :findings

  validates_presence_of :identity_url
  validates_presence_of :email
  validates_presence_of :nickname


end
