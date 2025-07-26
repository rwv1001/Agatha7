class CreateGroupTutorialSchedules < ActiveRecord::Migration
  def self.up
    create_table :group_tutorial_schedules do |t|
      t.integer :group_id, :default => 1
      t.integer :tutorial_schedule_id, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :group_tutorial_schedules
  end
end
