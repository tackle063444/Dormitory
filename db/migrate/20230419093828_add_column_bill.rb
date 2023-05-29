class AddColumnBill < ActiveRecord::Migration[5.1]
  def change
    create_table :bills do |t|
      t.references :rent, null: true, foreign_key: true
      t.references :bill_list, null: true, foreign_key: true
      t.references :hall, null: true, foreign_key: true
      t.date :bill_date
      t.string :bill_no
      t.integer :bill_total
      t.text :bill_remark

      t.timestamps
    end
  end
end
