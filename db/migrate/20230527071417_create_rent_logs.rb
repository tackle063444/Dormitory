class CreateRentLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :rent_logs do |t|

      t.timestamps
    end
  end
end
