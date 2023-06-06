class RemoveColumnInUserLog < ActiveRecord::Migration[5.2]
  def change
    remove_column :user_logs, :user_id
  end
end
