class CreateFormatElements < ActiveRecord::Migration
  def self.up
    create_table :format_elements do |t|
      t.integer :user_id, :default => 1
      t.string :table_name
      t.string :field_name
      t.string :insert_string
      t.integer :order 
    end
  end

  def self.down
    drop_table :format_elements
  end
end
