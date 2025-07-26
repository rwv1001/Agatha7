class CreateOpenRecords < ActiveRecord::Migration
  def self.up
    create_table :open_records do |t|
      t.integer :user_id, :default => 1
      t.string :table_name
      t.integer :record_id, :default => 1
      t.boolean :in_use

      t.timestamps
    end
  end

  def self.down
    drop_table :open_records
  end
end
