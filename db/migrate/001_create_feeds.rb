class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.string :title, :description, :link_regexp, :title_regexp, :content_regexp, :more_regexp
      t.text :link
      t.integer :more
      t.datetime :last_published
      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
  end
end
