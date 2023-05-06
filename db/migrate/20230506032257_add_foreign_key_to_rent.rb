class AddForeignKeyToRent < ActiveRecord::Migration[5.2]
  def change
    add_reference :rents, :hall, foreign_key: true
  end
end
