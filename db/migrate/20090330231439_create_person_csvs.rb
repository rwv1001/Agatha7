class CreatePersonCsvs < ActiveRecord::Migration
  def self.up
    create_table :person_csvs do |t|
      t.string :old_name
      t.string :title
      t.string :first_name
      t.string :second_name
      t.string :postnominals
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
      t.string :Fax
      t.text :Notes
      t.integer :supervisor
      t.integer :entry_year
      t.integer :matriculated
      t.boolean :senior_status
      t.integer :programme
      t.integer :religious_house
      t.string :next_of_kin
      t.integer :home_institution
      t.string :conventual_name

      
    end
  end

  def self.down
    drop_table :person_csvs
  end
end
