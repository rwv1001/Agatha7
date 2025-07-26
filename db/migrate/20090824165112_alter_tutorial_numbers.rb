class AlterTutorialNumbers < ActiveRecord::Migration
  def self.up
    remove_column :tutorials, :number_of_tutorials
    rename_column :tutorial_schedules, :total_tutorials, :number_of_tutorials
  end

  def self.down
    add_column :tutorials, :number_of_tutorials, :integer
    rename_column :tutorial_schedules, :number_of_tutorials, :total_tutorials
  end
end
