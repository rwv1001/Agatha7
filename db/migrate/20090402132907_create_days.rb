class CreateDays < ActiveRecord::Migration
  def self.up
    create_table :days do |t|
      t.string :long_name
      t.string :short_name
      t.boolean :Sunday
      t.boolean :Monday
      t.boolean :Tuesday
      t.boolean :Wednesday
      t.boolean :Thursday
      t.boolean :Friday
      t.boolean :Saturday

      t.timestamps
    end
  end

  def self.down
    drop_table :days
  end
end
