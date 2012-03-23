class RenameItemToEntry < ActiveRecord::Migration
  def change
    rename_table :items, :entries
  end
end
