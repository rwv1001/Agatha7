class CreateGroupEmailTemplates < ActiveRecord::Migration
  def self.up
    create_table :group_email_templates do |t|
      t.integer :group_id
      t.integer :email_template_id

      t.timestamps
    end
  end

  def self.down
    drop_table :group_email_templates
  end
end
