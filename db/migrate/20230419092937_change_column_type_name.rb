class ChangeColumnTypeName < ActiveRecord::Migration[5.1]
  def change
    change_column(:bill_lists, :unit_price, :float)
  end
end
