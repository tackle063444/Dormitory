class ChangeColumnTypeInRentLogs < ActiveRecord::Migration[5.2]
  def change
    change_column :rent_logs, :room_id, :integer
    change_column :rent_logs, :user_id, :integer
  end
end
