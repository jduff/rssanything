class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.string :title, :description, :link, :link_regexp, :title_regexp, :content_regexp, :more_regexp
      t.integer :more
      t.datetime :last_published
      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
  end
end
