#

class Finding < ActiveRecord::Base
  acts_as_taggable
  belongs_to :person
  belongs_to :image
end
