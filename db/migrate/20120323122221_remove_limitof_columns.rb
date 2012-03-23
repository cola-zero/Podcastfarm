class RemoveLimitofColumns < ActiveRecord::Migration
  def up
    change_column :entries, :title, :string, :limit => nil
    change_column :entries, :description, :string, :limit => nil
    change_column :entries, :enc_url, :string, :limit => nil
    change_column :feeds, :title, :string, :limit => nil
    change_column :feeds, :description, :string, :limit => nil
    change_column :feeds, :url, :string, :limit => nil
  end

  def down
    change_column :entries, :title, :string, :limit => 255
    change_column :entries, :description, :string, :limit => 255
    change_column :entries, :enc_url, :string, :limit => 255
    change_column :feeds, :title, :string, :limit => 255
    change_column :feeds, :description, :string, :limit => 255
    change_column :feeds, :url, :string, :limit => 255
  end
end
