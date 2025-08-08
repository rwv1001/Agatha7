class CreateSearchPreferences < ActiveRecord::Migration[7.2]
  def change
    create_table :search_preferences do |t|
      t.integer :user_id
      t.string :table_name
      t.string :preference_key
      t.text :preference_value

      t.timestamps
    end
    
    # Add index for fast lookups
    add_index :search_preferences, [:user_id, :table_name, :preference_key], 
              unique: true, name: 'index_search_prefs_on_user_table_key'
  end
end
