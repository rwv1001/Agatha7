class CreateTermNames < ActiveRecord::Migration
  def self.up
    create_table :term_names do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :term_names
  end
end
