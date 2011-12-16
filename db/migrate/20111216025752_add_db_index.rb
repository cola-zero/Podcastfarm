class AddDbIndex < ActiveRecord::Migration
  def change
    add_index :subscriptions, :user_id
    add_index :subscriptions, :feed_id
    add_index :authorizations, :user_id
    add_index :items, :feed_id
  end
end
