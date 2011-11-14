class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :title
      t.string :url, :null => false
      t.string :description

      t.timestamps
    end
    add_index :feeds, :url
  end
end
