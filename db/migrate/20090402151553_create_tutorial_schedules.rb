class CreateTutorialSchedules < ActiveRecord::Migration
  def self.up
    create_table :tutorial_schedules do |t|
      t.integer :person_id, :default => 1
      t.integer :course_id, :default => 1
      t.integer :term_id, :default => 1
      t.integer :total_tutorials, :default => 0
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :tutorial_schedules
  end
end
