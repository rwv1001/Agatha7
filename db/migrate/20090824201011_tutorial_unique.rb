class TutorialUnique < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE tutorials ADD CONSTRAINT unique_tutorials UNIQUE (person_id, tutorial_schedule_id); "
 end

  def self.down
     execute "ALTER TABLE tutorials DROP CONSTRAINT unique_tutorials;"
  end
end
