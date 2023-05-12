class ChangeColumnInHeadList < ActiveRecord::Migration[5.2]
  def change
    rename_column :head_lists, :bill_lists_id, :bill_list_id
  end
end
