namespace 'imageseek' do
  desc 'Create ImageSeek database'
  task 'create_db' => :environment do
    puts ImageSeek.create_database(1)
  end
  desc 'Reset ImageSeek database'
  task 'reset_db' => :environment do
    puts ImageSeek.reset_database(1)
  end
  desc 'Build database from images'
  task 'build_db' => :environment do
    Image.find(:all).each { |image|
      puts image.thumb_permalink
      puts ImageSeek.add_image(1, image.id, image.thumb_permalink)
      image.findings.each { |finding|
        finding.tags.collect { |tag|
          puts ImageSeek.add_keyword_to_image(1, image.id, tag.id)
        }
      }
      puts ImageSeek.find_keywords_for(1, image.id).inspect
    }
  end
  desc 'Save ImageSeek database'
  task 'save_db' => :environment do
    puts ImageSeek.save_databases
  end
  desc 'ImageSeek clusters'
  task 'clusters' => :environment do
    puts ImageSeek.clusters(1, 10).inspect
  end
end
