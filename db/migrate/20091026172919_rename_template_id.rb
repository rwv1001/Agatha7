class RenameTemplateId < ActiveRecord::Migration
  def self.up
     rename_column :agatha_emails, :template_id, :email_template_id
  end

  def self.down
    rename_column :agatha_emails, :email_template_id, :template_id
  end
end
