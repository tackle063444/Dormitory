class AddColumnToHeadList < ActiveRecord::Migration[5.2]
  def change
    add_column :head_lists, :old_unit, :integer
    add_column :head_lists, :new_unit, :integer
    add_column :head_lists, :e_price, :integer
    add_column :head_lists, :w_price, :integer
  end
end
