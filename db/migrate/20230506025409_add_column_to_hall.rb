class AddColumnToHall < ActiveRecord::Migration[5.2]
  def change
    add_column :halls, :codename_hall, :string
  end
end
