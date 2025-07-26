class RenameTableGroupMembersToGroupPerson < ActiveRecord::Migration
  def self.up
    rename_table :group_members, :group_people
  end

  def self.down
    rename_table :group_people, :group_members
  end
end
