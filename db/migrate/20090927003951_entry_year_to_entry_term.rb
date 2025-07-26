class EntryYearToEntryTerm < ActiveRecord::Migration
  def self.up
     rename_column :people, :entry_year, :entry_term_id
     add_column :people, :previous_studies, :text
     add_column :people, :interests, :text
  end

  def self.down
    rename_column :people, :entry_term_id , :entry_year
    remove_column :people, :previous_studies
    remove_column :people, :interests
  end
end
