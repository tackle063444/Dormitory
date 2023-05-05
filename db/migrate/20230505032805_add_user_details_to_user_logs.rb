class AddUserDetailsToUserLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :user_logs, :user_fname, :string
    add_column :user_logs, :user_lname, :string
    add_column :user_logs, :user_address, :string
    add_column :user_logs, :user_tel, :string
  end
end
