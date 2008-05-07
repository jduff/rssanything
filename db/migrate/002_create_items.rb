class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :title
      t.text :link
      t.binary :content
      t.integer :feed_id, :guid
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end