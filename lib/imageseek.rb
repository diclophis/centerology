#

class ImageSeek
  HOST = "localhost"
  PORT = 31128
  @@client = XMLRPC::Client.new(HOST, "/RPC", PORT)
  def self.databases
    return @@client.call('getDbList')
  end
  def self.create_database(id)
    return @@client.call('createDb', id.to_i)
  end
  def self.add_image(database_id, image_id, image_path)
    return @@client.call('addImg', database_id.to_i, image_id.to_i, image_path)
  end
  def self.find_images_similar_to(database_id, image_id, count = 10)
    return @@client.call('queryImgID', database_id.to_i, image_id.to_i, count)
  end
end
