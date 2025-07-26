class GroupInstitutionUnique < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE group_institutions ADD CONSTRAINT unique_group_institutions UNIQUE (group_id, institution_id); "
 end

  def self.down
     execute "ALTER TABLE group_institutions DROP CONSTRAINT unique_group_institutions;"
  end
end
