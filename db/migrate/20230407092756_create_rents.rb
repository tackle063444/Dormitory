class CreateRents < ActiveRecord::Migration[5.1]
  def change
    create_table :rents do |t|
      t.references :room, foreign_key: true
      t.references :user, foreign_key: true
      t.date :rent_start
      t.date :rent_end
      t.string :rent_history

      t.timestamps
    end
  end
end
