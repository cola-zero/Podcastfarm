class RemoveNotNullFromFeeds < ActiveRecord::Migration
  def up
    change_column :feeds, :url, :string, { :null => true }
  end

  def down
    change_column :feeds, :url, :string, { :null => false }
  end
end
