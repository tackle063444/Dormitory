class AddForeignKeyToBill < ActiveRecord::Migration[5.2]
  def change
    add_reference :bills, :hall, foreign_key: true
  end
end
