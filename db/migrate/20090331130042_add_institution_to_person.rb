class AddInstitutionToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :institution, :integer, :default => 1
  end

  def self.down
    remove_column :people, :institution
  end
end
