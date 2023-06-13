class AddColumnNameToBills < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :bill_signature, :string
  end
end
