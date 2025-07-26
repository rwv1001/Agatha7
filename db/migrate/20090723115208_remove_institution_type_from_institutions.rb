class RemoveInstitutionTypeFromInstitutions < ActiveRecord::Migration
  def self.up
    remove_column :institutions, :institution_type
  end

  def self.down
    add_column :institutions, :institution_type, :boolean
  end
end
