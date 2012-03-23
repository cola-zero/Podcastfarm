class AddEnclosureToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :enc_url, :string
    add_column :entries, :enc_length, :integer
    add_column :entries, :enc_type, :string
  end
end
