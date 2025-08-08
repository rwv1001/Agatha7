class CreateUserSearchStates < ActiveRecord::Migration[7.2]
  def change
    create_table :user_search_states do |t|
      t.integer :user_id
      t.string :table_name
      t.text :current_filter_indices
      t.text :search_order
      t.text :search_direction
      t.text :search_indices
      t.boolean :active

      t.timestamps
    end
  end
end
