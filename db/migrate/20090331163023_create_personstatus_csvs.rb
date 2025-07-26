class CreatePersonstatusCsvs < ActiveRecord::Migration
  def self.up
    create_table :personstatus_csvs do |t|
      t.integer :person_id
      t.integer :status_id

     
    end
  end

  def self.down
    drop_table :personstatus_csvs
  end
end
