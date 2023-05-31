class AddColumnInRentLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :rent_logs, :rent_id, :integer
  end
end
