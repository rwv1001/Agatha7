class GroupLectureUnique < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE group_lectures ADD CONSTRAINT unique_group_lectures UNIQUE (group_id, lecture_id); "
 end

  def self.down
     execute "ALTER TABLE group_lectures DROP CONSTRAINT unique_group_lectures;"
  end
end
