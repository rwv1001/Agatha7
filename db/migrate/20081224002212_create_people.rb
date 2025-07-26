class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :title
      t.string :first_name
      t.string :second_name
      t.string :postnomials
      t.string :salutation
      t.string :term_address
      t.string :term_city
      t.string :term_postcode
      t.string :term_home_phone
      t.string :term_work_phone
      t.string :mobile
      t.string :email
      t.string :other_address
      t.string :other_city
      t.string :other_postcode
      t.string :other_home_phone
      t.string :fax
      t.text :notes
      t.integer :entry_year, :null => false, :default => 1
      t.string :next_of_kin
      t.string :conventual_name

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
