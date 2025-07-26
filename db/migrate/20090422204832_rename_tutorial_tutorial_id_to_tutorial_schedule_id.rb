class RenameTutorialTutorialIdToTutorialScheduleId < ActiveRecord::Migration
  def self.up
     rename_column :tutorials, :tutorial_id, :tutorial_schedule_id
  end

  def self.down
    rename_column :tutorials, :tutorial_schedule_id , :tutorial_id
  end
end
