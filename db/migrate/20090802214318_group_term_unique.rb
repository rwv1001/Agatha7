class GroupTermUnique < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE group_terms ADD CONSTRAINT unique_group_terms UNIQUE (group_id, term_id); "
 end

  def self.down
     execute "ALTER TABLE group_terms DROP CONSTRAINT unique_group_terms;"
  end
end
