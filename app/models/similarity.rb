#

class Similarity < ActiveRecord::Base
  belongs_to :image, :class_name => "Image"
  belongs_to :similar_image, :class_name => "Image"
end
