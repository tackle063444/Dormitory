class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.references :hall, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.string :room_num
      t.boolean :room_status

      t.timestamps
    end
  end
end
