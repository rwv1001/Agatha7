class CreateGroupTermNames < ActiveRecord::Migration
  def self.up
    create_table :group_term_names do |t|
      t.integer :group_id, :default => 1
      t.integer :term_name_id, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :group_term_names
  end
end
