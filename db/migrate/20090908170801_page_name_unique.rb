class PageNameUnique < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE user_pages ADD CONSTRAINT unique_page_names UNIQUE (user_id, page_name); "
  end

  def self.down
     execute "ALTER TABLE user_pages DROP CONSTRAINT unique_page_names;"
  end
end
