class CreateTerms < ActiveRecord::Migration
  def self.up
    create_table :terms do |t|
      t.integer :term_number, :default => 1
      t.integer :year

      t.timestamps
    end
  end

  def self.down
    drop_table :terms
  end
end
