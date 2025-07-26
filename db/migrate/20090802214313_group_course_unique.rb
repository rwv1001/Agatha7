class GroupCourseUnique < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE group_courses ADD CONSTRAINT unique_group_courses UNIQUE (group_id, course_id); "
 end

  def self.down
     execute "ALTER TABLE group_courses DROP CONSTRAINT unique_group_courses;"
  end
end
