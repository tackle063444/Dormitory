class AddActionToRentLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :rent_logs, :action, :string
    add_reference :rent_logs, :room, foreign_key: true
    add_column :rent_logs, :rent_start, :string
    add_column :rent_logs, :rent_end, :string
    add_reference :rent_logs, :user, foreign_key: true
  end
end
