class AddColumnBill < ActiveRecord::Migration[5.1]
  def change
    add_column :bills, :room_id, :integer
    add_foreign_key :bills, :rooms, column: :room_id
    add_column :bills, :old_unit, :float
    add_column :bills, :new_unit, :float
  end
end
