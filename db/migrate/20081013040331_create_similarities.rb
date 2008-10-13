class CreateSimilarities < ActiveRecord::Migration
  def self.up
    create_table :similarities do |t|
      t.integer :image_id
      t.integer :similar_image_id
      t.float :rating
      t.timestamps
    end
  end

  def self.down
    drop_table :similarities
  end
end
