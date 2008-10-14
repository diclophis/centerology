namespace 'imageseek' do
  desc 'Create Similarities'
  task 'create_similarities' => :environment do
    ImageSeek.daemon {
      if (Image.count(:conditions => ["created_at > ?", (1.5).hours.ago]) > 0) then
        length = 30
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
            tags = image.findings.tag_counts.collect { |tag| tag.id }.join(",")
            similar_with_tags_and = ImageSeek.find_images_similar_with_keywords_to(database, image.id, 4, tags, 1).collect { |image_id, rating|
              unless image.id == image_id then
                similar_image = Image.find(image_id)
                #similar_image.rating = rating
                [similar_image, rating, "and"]
              end
            }
            similar_with_tags_or = ImageSeek.find_images_similar_with_keywords_to(database, image.id, 4, tags, 0).collect { |image_id, rating|
              unless image.id == image_id then
                similar_image = Image.find(image_id)
                #similar_image.rating = rating
                [similar_image, rating, "or"]
              end
            }
            similar_without_tags = ImageSeek.find_images_similar_to(database, image.id, 4).collect { |image_id, rating|
              unless image.id == image_id then
                similar_image = Image.find(image_id)
                #similar_image.rating = rating
                [similar_image, rating, "without"]
              end
            }
            (similar_with_tags_and + similar_with_tags_or + similar_without_tags).compact.each { |similar_image, rating, join_type|
              similarity = Similarity.new
              similarity.image_id = image.id
              similarity.similar_image_id = similar_image.id
              similarity.rating = rating
              similarity.join_type = join_type
              similarity.save!
            }
          }
        end
      end
    }
  end
end
