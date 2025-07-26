class AddInUseToFormatElements < ActiveRecord::Migration
  def self.up
    add_column :format_elements, :in_use, :bool
  end

  def self.down
    remove_column :format_elements, :in_use
  end
end
