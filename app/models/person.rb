#

class Person < ActiveRecord::Base
  has_many_friends
  has_many :findings
  has_many :images, :through => :findings
  has_many :last_three_images, :source => :image, :through => :findings, :limit => 3, :order => 'created_at DESC'
  before_validation :prepend_identity_url
  validates_presence_of :identity_url
  validates_as_uri :identity_url
  validates_as_email :email
  validates_presence_of :email
  validates_presence_of :nickname
  validates_uniqueness_of :nickname
  def prepend_identity_url
    unless identity_url.index("http") == 0 then
      self.identity_url = "http://#{identity_url}"
    end
  end
  def to_s
    nickname
  end
  def to_param
    nickname
  end
end
