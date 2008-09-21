class AddPermalinkToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :permalink, :string, :limit => 255, :null => false
  end

  def self.down
  end
end
