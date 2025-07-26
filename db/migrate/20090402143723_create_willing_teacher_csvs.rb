class CreateWillingTeacherCsvs < ActiveRecord::Migration
  def self.up
    create_table :willing_teacher_csvs do |t|
      t.integer :tutor
      t.integer :course
      t.text :notes


    end
  end

  def self.down
    drop_table :willing_teacher_csvs
  end
end
