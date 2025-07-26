class RenameTermNumberToTermNameId < ActiveRecord::Migration
  def self.up
    rename_column :terms, :term_number, :term_name_id
  end

  def self.down
    rename_column :terms, :term_name_id, :term_number
  end
end
