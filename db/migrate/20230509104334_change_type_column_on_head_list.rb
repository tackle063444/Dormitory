class ChangeTypeColumnOnHeadList < ActiveRecord::Migration[5.2]
  def change
    change_column :head_lists, :old_unit, :float
    change_column :head_lists, :new_unit, :float
    change_column :head_lists, :e_price, :float
    change_column :head_lists, :w_price, :float
  end
end
