class RenamelistTypeTableTobillLists < ActiveRecord::Migration[5.2]
  def change
    rename_table :list_type ,:bill_lists
  end
end
