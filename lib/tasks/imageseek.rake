namespace 'imageseek' do
  desc 'Create Similarities'
  task 'create_similarities' => :environment do
    ImageSeek.daemon {
      length = 20
      database = Time.now.to_i
      ImageSeek.create(database)
      images = Image.find(:all)
      images.each { |image|
        ImageSeek.add_image(database, image.id, image.thumb_permalink)
        image.findings.each { |finding|
          finding.tags.collect { |tag|
            ImageSeek.add_keyword_to_image(database, image.id, tag.id)
          }
        }
      }
      Similarity.transaction do
        images.each { |image|
          tags = image.findings.first.tags.collect { |tag| tag.id }.join(",")
          similar_with_tags = ImageSeek.find_images_similar_with_keywords_to(database, image.id, length, tags).collect { |image_id, rating|
            unless image.id == image_id then
              similar_image = Image.find(image_id)
              similar_image.rating = rating
              similar_image
            end
          }
          if similar_with_tags.length < length then
            similar = ImageSeek.find_images_similar_to(database, image.id, length).collect { |image_id, rating|
              unless image.id == image_id then
                similar_image = Image.find(image_id)
                similar_image.rating = rating
                similar_image
              end
            }
          else
            similar = []
          end
          (similar_with_tags + similar).compact.uniq.slice(0, length).each { |similar_image|
            similarity = Similarity.new
            similarity.image_id = image.id
            similarity.similar_image_id = similar_image.id
            similarity.rating = similar_image.rating
            similarity.save!
          }
        }
      }
    }
  end
end
