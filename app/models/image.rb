#

class Image < ActiveRecord::Base
  has_many :findings, :order => :created_at
  has_one :latest_finding, :class_name => 'Finding', :order => :created_at
  validates_presence_of :title
  validates_presence_of :src
  validates_as_uri :src
  attr_accessor :similarity
  def public_link(x_key = :main)
    Aws.get_key(x_key, self.permalink).public_link
  end
  def thumb_permalink
    public_link(:thumb)
  end
  def full_permalink
    public_link(:main)
  end
  def icon_permalink
    public_link(:icon)
  end
  def x_put (blob)
    self.permalink = UUID.random_create.to_s if self.permalink.blank?
    imgs = Magick::Image.from_blob(blob)
    first = imgs.first
    case first.get_exif_by_entry("Orientation") && first["EXIF:Orientation"]
      when "6"
        first.rotate!(90)
        first["EXIF:Orientation"] = "1"
      when "3"
        first.rotate!(180)
        first["EXIF:Orientation"] = "1"
      when "8"
        first.rotate!(270)
        first["EXIF:Orientation"] = "1"
    end
    sizes = {
      :main => {:cols => 640, :rows => 480},
      :thumb => {:cols => 400},
      :icon => {:cols => 128}
    }.each { |x_key, size|
      geometry = if size[:rows] then
        "#{size[:cols]}x#{size[:rows]}>"
      else
        "#{size[:cols]}x"
      end
      first.change_geometry(geometry) { |cols, rows, img|
        resized_blob = img.resize(cols, rows).to_blob
        local = File.new("/tmp/#{self.permalink}_#{x_key}", "w+")
        local.write(resized_blob)
        local.close
        Aws.put_key(x_key, self.permalink, resized_blob)
      }
    }
  end
  def similar_images(length = 10)
    similar_with_tags = ImageSeek.find_images_similar_with_keywords_to(1, self.id, length, self.findings.first.tags.collect { |tag| tag.id }.join(",")).collect { |image_id, similarity|
    logger.debug(similarity)
      unless self.id == image_id then
        image = Image.find(image_id) unless self.id == image_id
        image.similarity = similarity
        image
      end
    }.compact
    logger.debug(similar_with_tags.inspect)
    if similar_with_tags.length < length then
      similar = ImageSeek.find_images_similar_to(1, self.id, length).collect { |image_id, similarity|
        unless self.id == image_id then
          image = Image.find(image_id)
          image.similarity = similarity
          image
        end
      }.compact
      logger.debug(similar.inspect)
    else
      similar = []
    end
    (similar_with_tags + similar).uniq.slice(0, length)
  end
end
