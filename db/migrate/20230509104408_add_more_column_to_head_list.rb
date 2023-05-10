class AddMoreColumnToHeadList < ActiveRecord::Migration[5.2]
  def change
    add_column :head_lists, :amount, :float
  end
end
