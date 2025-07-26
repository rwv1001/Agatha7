class CreateGroupDays < ActiveRecord::Migration
  def self.up
    create_table :group_days do |t|
      t.integer :group_id, :default => 1
      t.integer :day_id, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :group_days
  end
end
