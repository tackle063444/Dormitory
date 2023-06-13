class AddColumnToHeadList2 < ActiveRecord::Migration[5.2]
  def change
    add_column :head_lists, :re_value, :float
  end
end
