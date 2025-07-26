class CreateGroupTerms < ActiveRecord::Migration
  def self.up
    create_table :group_terms do |t|
      t.integer :group_id, :default => 1
      t.integer :term_id, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :group_terms
  end
end
