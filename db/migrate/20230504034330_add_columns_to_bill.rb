class AddColumnsToBill < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :w_price, :float
    add_column :bills, :e_price, :float
  end
end
