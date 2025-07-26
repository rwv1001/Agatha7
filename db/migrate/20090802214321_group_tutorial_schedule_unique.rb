class GroupTutorialScheduleUnique < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE group_tutorial_schedules ADD CONSTRAINT unique_group_tutorial_schedules UNIQUE (group_id, tutorial_schedule_id); "
 end

  def self.down
     execute "ALTER TABLE group_tutorial_schedules DROP CONSTRAINT unique_group_tutorial_schedules;"
  end
end
