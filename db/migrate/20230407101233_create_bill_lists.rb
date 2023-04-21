class CreateBillLists < ActiveRecord::Migration[5.1]
  def change
    create_table :bill_lists do |t|
      #t.references :list_type, foreign_key: true
      t.boolean :is_pay
      t.timestamps
    end
  end
end
