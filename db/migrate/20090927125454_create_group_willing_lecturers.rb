class CreateGroupWillingLecturers < ActiveRecord::Migration
  def self.up
    create_table :group_willing_lecturers do |t|
      t.integer :group_id
      t.integer :willing_lecturer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :group_willing_lecturers
  end
end
