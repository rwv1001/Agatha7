class CreateDisplayFilters < ActiveRecord::Migration
  def self.up
    create_table :display_filters do |t|
      t.integer :user_id, :default => 1
      t.string :table_name
      t.integer :filter_index
      t.integer :element_order
      t.boolean :in_use
    end
  end

  def self.down
    drop_table :display_filters
  end
end
