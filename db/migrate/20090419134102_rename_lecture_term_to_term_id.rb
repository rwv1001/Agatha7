class RenameLectureTermToTermId < ActiveRecord::Migration
  def self.up
    rename_column :lectures, :term, :term_id
    rename_column :lectures, :day, :day_id
    rename_column :lectures, :location, :location_id
  end

  def self.down
    rename_column :lectures, :term_id, :term
    rename_column :lectures, :day_id, :day
    rename_column :lectures, :location_id, :location
  end
end
