class AddNewColumnTomoreList < ActiveRecord::Migration[5.2]
  def change
    add_column :more_lists, :name_morelist, :string
    add_column :more_lists, :unit_morelist, :float
    add_column :more_lists, :type_morelist, :string
  end
end
