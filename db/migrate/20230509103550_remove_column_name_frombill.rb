class RemoveColumnNameFrombill < ActiveRecord::Migration[5.2]
  def change
    remove_column :bills, :old_unit
    remove_column :bills, :new_unit
    remove_column :bills, :e_price
    remove_column :bills, :w_price
  end
end
