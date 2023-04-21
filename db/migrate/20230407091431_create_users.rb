class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :user_fname
      t.string :user_lname
      t.string :user_address
      t.integer :user_tel

      t.timestamps
    end
  end
end
