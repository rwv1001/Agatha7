class CreateInstitutions < ActiveRecord::Migration
  def self.up
    create_table :institutions do |t|
      t.string :old_name
      t.string :title
      t.string :first_name
      t.string :second_name
      t.string :salutation
      t.string :term_address
      t.string :term_city
      t.string :term_postcode
      t.string :conventual_name
      t.boolean :institution_type

      t.timestamps
    end
  end

  def self.down
    drop_table :institutions
  end
end
