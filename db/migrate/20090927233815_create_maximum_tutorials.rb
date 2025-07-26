class CreateMaximumTutorials < ActiveRecord::Migration
  def self.up
    create_table :maximum_tutorials do |t|
      t.integer :person_id
      t.integer :max_tutorials
      t.integer :term_id

      t.timestamps
    end
  end

  def self.down
    drop_table :maximum_tutorials
  end
end
