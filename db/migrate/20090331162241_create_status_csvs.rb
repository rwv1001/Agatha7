class CreateStatusCsvs < ActiveRecord::Migration
  def self.up
    create_table :status_csvs do |t|
      t.string :status
      t.boolean :student
      t.boolean :tutor
      t.integer :sort_key

     
    end
  end

  def self.down
    drop_table :status_csvs
  end
end
