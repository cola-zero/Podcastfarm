class AddGuidToItem < ActiveRecord::Migration
  def change
    add_column :items, :guid, :string
  end
end
