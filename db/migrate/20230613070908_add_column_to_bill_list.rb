class AddColumnToBillList < ActiveRecord::Migration[5.2]
  def change
    add_column :bill_lists, :check_list, :boolean
  end
end
