class CreateAgathaFiles < ActiveRecord::Migration
  def self.up
    create_table :agatha_files do |t|
      t.integer :person_id, :default => 1
      t.integer :course_id, :default => 1
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :agatha_files
  end
end
