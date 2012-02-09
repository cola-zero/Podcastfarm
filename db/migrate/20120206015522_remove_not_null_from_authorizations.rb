class RemoveNotNullFromAuthorizations < ActiveRecord::Migration
  def self.up
    change_column :authorizations, :provider, :string, { :null => true }
    change_column :authorizations, :uid, :string, { :null => true }
    change_column :authorizations, :user_id, :integer, { :null => true }
  end

  def self.down
    change_column :authorizations, :provider, :string, { :null => false }
    change_column :authorizations, :uid, :string, { :null => false }
    change_column :authorizations, :user_id, :integer, { :null => false }
  end
end
