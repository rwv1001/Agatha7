class CreateTermCsvs < ActiveRecord::Migration
  def self.up
    create_table :term_csvs do |t|
      t.integer :name
      t.timestamp :startdate
      t.integer :year
    end
  end

  def self.down
    drop_table :term_csvs
  end
end
