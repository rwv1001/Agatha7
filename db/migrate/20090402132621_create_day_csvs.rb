class CreateDayCsvs < ActiveRecord::Migration
  def self.up
    create_table :day_csvs do |t|
      t.string :long_name
      t.string :short_name


    end
  end

  def self.down
    drop_table :day_csvs
  end
end
