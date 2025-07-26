class CreateLectureCsvs < ActiveRecord::Migration
  def self.up
    create_table :lecture_csvs do |t|
      t.integer :term
      t.integer :course
      t.integer :tutor
      t.integer :number_of_lectures
      t.integer :number_of_classes
      t.integer :hours
      t.text :notes
      t.string :examination
      t.integer :day
      t.timestamp :lecture_time
      t.string :week

     
    end
  end

  def self.down
    drop_table :lecture_csvs
  end
end
