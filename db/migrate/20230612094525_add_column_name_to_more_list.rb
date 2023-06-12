class AddColumnNameToMoreList < ActiveRecord::Migration[5.2]
  def change
    add_reference :more_lists, :hall, foreign_key: true
  end
end
