class AddParamsToLecture < ActiveRecord::Migration
  def self.up
    remove_column :lectures, :hour
    remove_column :lectures, :year
    remove_column :lectures, :day
    add_column :lectures, :day, :integer
    add_column :lectures, :lecture_time, :time
    add_column :lectures, :location, :integer, :default => 1
    add_column :lectures, :number_of_classes, :integer, :default => 0
    add_column :lectures, :number_of_lectures, :integer, :default => 0
    add_column :lectures, :hours, :integer, :default => 0
    add_column :lectures, :notes, :text
    
  end

  def self.down
    
    remove_column :lectures, :notes
    remove_column :lectures, :hours
    remove_column :lectures, :number_of_lectures
    remove_column :lectures, :number_of_classes
    remove_column :lectures, :location
    remove_column :lectures, :lecture_time
    remove_column :lectures, :day
    add_column :lectures, :day, :text
    add_column :lectures, :year, :integer
    add_column :lectures, :hour, :text	
  end
end
