class CreateFindings < ActiveRecord::Migration
  def self.up
    create_table :findings do |t|
      t.integer :person_id
      t.integer :image_id
      t.text :notes
      t.integer :position
      t.timestamps
    end
  end

  def self.down
    drop_table :findings
  end
end
