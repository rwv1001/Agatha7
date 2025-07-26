class CreateCourseCsvs < ActiveRecord::Migration
  def self.up
    create_table :course_csvs do |t|
      t.string :course_name
      t.string :paper_number
      t.boolean :studium_course
      t.boolean :evening_course


    end
  end

  def self.down
    drop_table :course_csvs
  end
end
