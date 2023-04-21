class CreateBills < ActiveRecord::Migration[5.1]
  def change
    create_table :bills do |t|
      t.references :room, foreign_key: true
      t.references :rent, foreign_key: true
      t.references :bill_list, foreign_key: true
      t.date :bill_date
      t.string :bill_no
      t.float :bill_total
      t.string :bill_remark
      t.integer :old_unit
      t.integer :new_unit
      t.timestamps
    end
  end
end
