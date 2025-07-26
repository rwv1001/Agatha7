class AddHtmlEmail < ActiveRecord::Migration
  def self.up
    add_column :people, :html_email, :boolean, :default => true
  end

  def self.down
    remove_column :people, :html_email
  end
end
