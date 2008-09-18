#

class Person < ActiveRecord::Base
  validates_presence_of :identity_url
  validates_presence_of :email
  validates_presence_of :nickname
end
