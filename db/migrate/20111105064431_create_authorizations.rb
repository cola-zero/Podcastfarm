class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :provider, :null => false
      t.string :uid, :null => false
      t.integer :user_id, :null => false

      t.timestamps
    end
    add_index :authorizations, [:provider, :uid]
  end
end
