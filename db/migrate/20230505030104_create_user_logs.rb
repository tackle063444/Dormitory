class CreateUserLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :user_logs do |t|
      t.string :action
      t.integer :user_id

      t.timestamps
    end
  end
end
