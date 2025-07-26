class CreateTutorialCsvs < ActiveRecord::Migration
  def self.up
    create_table :tutorial_csvs do |t|
      t.integer :student
      t.integer :term
      t.integer :course
      t.integer :tutor
      t.integer :number
      t.string :mark
      t.integer :hours
      t.text :notes

   
    end
  end

  def self.down
    drop_table :tutorial_csvs
  end
end
