class AddColumnToHeadList1 < ActiveRecord::Migration[5.2]
  def change
    add_column :head_lists, :check_list, :boolean
  end
end
