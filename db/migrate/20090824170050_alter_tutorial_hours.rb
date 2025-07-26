class AlterTutorialHours < ActiveRecord::Migration
  def self.up
    remove_column :tutorials, :hours
    add_column :tutorial_schedules, :number_of_tutorial_hours, :integer, :default => 0
  end

  def self.down
     remove_column :tutorial_schedules, :number_of_tutorial_hours
    add_column :tutorials, :hours, :integer
  end
end
