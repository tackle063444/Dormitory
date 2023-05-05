class ChangeRoomStatusToRooms < ActiveRecord::Migration[5.2]
  def change
    change_column :rooms, :room_status, :string
  end
end
