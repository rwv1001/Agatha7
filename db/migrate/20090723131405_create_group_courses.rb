class CreateGroupCourses < ActiveRecord::Migration
  def self.up
    create_table :group_courses do |t|
      t.integer :group_id, :default => 1
      t.integer :course_id, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :group_courses
  end
end
