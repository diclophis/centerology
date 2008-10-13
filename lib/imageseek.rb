#

class ImageSeek
  HOST = "localhost"
  PORT = 31128
  @@client = XMLRPC::Client.new(HOST, "/RPC", PORT)
  def self.databases
    return @@client.call('getDbList')
  end
  def self.save_databases
    return @@client.call('saveAllDbs')
  end
  def self.create_database(id)
    return @@client.call('createDb', id.to_i)
  end
  def self.reset_database(id)
    return @@client.call('resetDb', id.to_i)
  end
  def self.clusters(id, count = 10)
    return @@client.call('getClusterDb', id.to_i, count)
  end
  def self.add_image(database_id, image_id, image_path, is_url = true)
    return @@client.call('addImg', database_id.to_i, image_id.to_i, image_path, is_url)
  end
  def self.add_keyword_to_image(database_id, image_id, keyword)
    return @@client.call('addKeywordImg', database_id.to_i, image_id.to_i, keyword)
  end
  def self.add_keywords_to_image(database_id, image_id, keywords)
    return @@client.call('addKeywordsImg', database_id.to_i, image_id.to_i, keywords)
  end
  def self.find_keywords_for(database_id, image_id)
    return @@client.call('getKeywordsImg', database_id.to_i, image_id.to_i)
  end
  def self.find_images_similar_to(database_id, image_id, count = 10)
    return @@client.call('queryImgID', database_id.to_i, image_id.to_i, count)
  rescue
    []
  end
  def self.find_images_similar_with_keywords_to(database_id, image_id, count = 10, keywords = "")
    return @@client.call('queryImgIDKeywords', database_id.to_i, image_id.to_i, count, 0, keywords)
  rescue
    []
  end
end
