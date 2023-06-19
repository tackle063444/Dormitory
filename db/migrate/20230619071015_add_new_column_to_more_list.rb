class AddNewColumnToMoreList < ActiveRecord::Migration[5.2]
  def change
    add_column :more_lists, :more_list_date, :date
  end
end
