class AddJoinTypeToSimilarities < ActiveRecord::Migration
  def self.up
    add_column :similarities, :join_type, :string, :limit => 255, :null => false
  end

  def self.down
  end
end
