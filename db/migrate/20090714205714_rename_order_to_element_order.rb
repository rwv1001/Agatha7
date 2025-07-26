class RenameOrderToElementOrder < ActiveRecord::Migration
  def self.up
     rename_column :format_elements, :order, :element_order
  end

  def self.down
    rename_column :format_elements, :element_order, :order
  end
end
