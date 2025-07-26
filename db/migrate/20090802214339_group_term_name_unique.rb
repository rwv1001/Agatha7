class GroupTermNameUnique < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE group_term_names ADD CONSTRAINT unique_group_term_names UNIQUE (group_id, term_name_id); "
 end

  def self.down
     execute "ALTER TABLE group_term_names DROP CONSTRAINT unique_group_term_names;"
  end
end
