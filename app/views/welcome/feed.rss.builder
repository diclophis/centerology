xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "feed"
    xml.description "feed"
    xml.link(feed_url(@feeder))
    @feeder.last_three_images.each { |image|
      xml.item do
        xml.title(image.title)
        xml.description(image_tag(image.thumb_permalink))
        xml.pubDate(image.created_at.to_s(:rfc822))
        xml.link(image_url(image.permalink))
      end
    }
  end
end

