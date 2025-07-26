class CreateGroupTutorials < ActiveRecord::Migration
  def self.up
    create_table :group_tutorials do |t|
      t.integer :group_id, :default => 1
      t.integer :tutorial_id, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :group_tutorials
  end
end
