class ChangeTextToString < ActiveRecord::Migration
  def self.up
     change_column :groups, :table_name, :string
     change_column :lectures, :exam, :string
     change_column :group_filters, :table_name, :string
  end

  def self.down
    change_column :groups, :table_name, :text
    change_column :lectures, :exam, :text
    change_column :group_filters, :table_name, :text
  end
end
