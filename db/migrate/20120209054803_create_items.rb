class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.string :description
      t.integer :feed_id

      t.timestamps
    end
    add_index :items, :feed_id
  end
end
