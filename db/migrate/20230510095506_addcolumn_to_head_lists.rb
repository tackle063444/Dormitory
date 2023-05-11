class AddcolumnToHeadLists < ActiveRecord::Migration[5.2]
  def change
    add_column :head_lists, :head_total, :float
  end
end
