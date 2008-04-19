class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :title, :link, :guid
      t.binary :content
      t.integer :feed_id
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end