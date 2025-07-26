class CreateGroupFilters < ActiveRecord::Migration
  def self.up
    create_table :group_filters do |t|
      t.integer :user_id, :default => 1
      t.text :table_name
      t.text :foreign_key
      t.integer :group_id, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :group_filters
  end
end
