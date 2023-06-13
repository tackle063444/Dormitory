class AddColumnToBillList1 < ActiveRecord::Migration[5.2]
  def change
    add_column :bill_lists, :name_unit, :string
  end
end
