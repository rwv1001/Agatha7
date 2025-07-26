class AddCollectionStatusToTutorial < ActiveRecord::Migration
  def self.up
    add_column :tutorials, :collection_status, :integer
    add_column :tutorials, :collection_mark, :string
  end

  def self.down
    remove_column :tutorials, :collection_mark
    remove_column :tutorials, :collection_status
  end
end
