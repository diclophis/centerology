#

class Person < ActiveRecord::Base
  has_many_friends
  has_many :findings
  has_many :images, :through => :findings
  validates_presence_of :identity_url
  validates_as_uri :identity_url
  validates_presence_of :email
  validates_presence_of :nickname
  validates_uniqueness_of :nickname
  def to_s
    nickname
  end
  def to_param
    nickname
  end
end
