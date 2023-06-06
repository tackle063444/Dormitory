class RemoveColumnInRentLog < ActiveRecord::Migration[5.2]
  def change
    remove_column :rent_logs, :user_id
    remove_column :rent_logs, :room_id
  end
end
