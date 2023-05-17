class ChangeColumnTypeInUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :user_tel, :string
  end
end
