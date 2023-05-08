class AddBillIdToBillLists < ActiveRecord::Migration[5.2]
  def change
    add_reference :bill_lists, :bill, foreign_key: true
  end
end
