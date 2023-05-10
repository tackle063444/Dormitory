class RenamebillListTableTolistType < ActiveRecord::Migration[5.2]
  def change
    rename_table :bill_lists, :list_type
  end
end
