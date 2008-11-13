#

class Visualizeus
  URL = "http://feeds.feedburner.com/visualizeus/popular/"
  def self.images
    rss = Fast.fetch(URL)
    doc = Hpricot.XML(rss)
    doc.entries.each { |entry|
      yield [entry.url, Hpricot(entry.content).at("img").attributes["src"]]
    }
  end
end
