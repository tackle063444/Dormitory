class AddMoreColumnInRentLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :rent_logs, :user_fname, :string
    add_column :rent_logs, :user_lname, :string
    add_column :rent_logs, :room_num, :string
  end
end
