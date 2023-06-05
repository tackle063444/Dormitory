class AddBillIdToHeadLists < ActiveRecord::Migration[5.2]
  def change
    add_reference :head_lists, :bill, foreign_key: true
  end
end
