class CreateGroupInstitutions < ActiveRecord::Migration
  def self.up
    create_table :group_institutions do |t|
      t.integer :group_id, :default => 1
      t.integer :institution_id, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :group_institutions
  end
end
