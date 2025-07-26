class CreateUserPages < ActiveRecord::Migration
  def self.up
    create_table :user_pages do |t|
      t.integer :user_id, :default => 1
      t.string :page_name, :default => "Person"
      t.integer :option_id, :default => 0
      t.boolean :is_active, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :user_pages
  end
end
