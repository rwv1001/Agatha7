class CreateExternalFilterValues < ActiveRecord::Migration
  def self.up
    create_table :external_filter_values do |t|
      t.integer :user_id, :default => 1
      t.string :table_name
      t.integer :filter_id, :default => 1
      t.integer :member_id, :default => 1
      t.integer :group_id, :default => 1
      t.boolean :in_use

      t.timestamps
    end
  end

  def self.down
    drop_table :external_filter_values
  end
end
