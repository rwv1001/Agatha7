class CreateAttendeeCsvs < ActiveRecord::Migration
  def self.up
    create_table :attendee_csvs do |t|
      t.integer :student
      t.integer :lectures_course
      t.boolean :compulsory
      t.boolean :examined
      t.string :mark

  
    end
  end

  def self.down
    drop_table :attendee_csvs
  end
end
