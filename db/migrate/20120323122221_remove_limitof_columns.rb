class RemoveLimitofColumns < ActiveRecord::Migration
  def up
    change_column :entries, :title, :text, :limit => nil
    change_column :entries, :description, :text, :limit => nil
    change_column :entries, :enc_url, :text, :limit => nil
    change_column :feeds, :title, :text, :limit => nil
    change_column :feeds, :description, :text, :limit => nil
    change_column :feeds, :url, :text, :limit => nil
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
