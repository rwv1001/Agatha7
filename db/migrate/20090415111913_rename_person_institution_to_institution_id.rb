class RenamePersonInstitutionToInstitutionId < ActiveRecord::Migration
  def self.up
     rename_column :people, :institution, :institution_id
     rename_column :people, :religious_house, :religious_house_id
  end

  def self.down
     rename_column :people, :institution_id , :institution
     rename_column :people, :religious_house_id , :religious_house
  end
end
