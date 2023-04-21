class AddColumnOnBillLists < ActiveRecord::Migration[5.1]
  def change
    add_column :bill_lists, :unit_price, :float
    add_column :bill_lists, :list_typeName, :string
  end
end
