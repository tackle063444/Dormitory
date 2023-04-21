class CreateHalls < ActiveRecord::Migration[5.1]
  def change
    create_table :halls do |t|
      t.string :hall_name
      t.string :hall_address
      t.string :hall_tel
      t.string :hall_logo

      t.timestamps
    end
  end
end
