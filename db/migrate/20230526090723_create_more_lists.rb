class CreateMoreLists < ActiveRecord::Migration[5.2]
  def change
    create_table :more_lists do |t|

      t.timestamps
    end
  end
end
