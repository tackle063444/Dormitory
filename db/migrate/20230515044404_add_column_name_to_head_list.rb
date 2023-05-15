class AddColumnNameToHeadList < ActiveRecord::Migration[5.2]
  def change
    add_column :head_lists, :two_r, :string
  end
end
