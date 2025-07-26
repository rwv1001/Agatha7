class CreateGroupWillingTutors < ActiveRecord::Migration
  def self.up
    create_table :group_willing_tutors do |t|
      t.integer :group_id
      t.integer :willing_tutor_id

      t.timestamps
    end
  end

  def self.down
    drop_table :group_willing_tutors
  end
end
