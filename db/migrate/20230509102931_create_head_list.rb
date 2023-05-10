class CreateHeadList < ActiveRecord::Migration[5.2]
  def change
    create_table :head_lists do |t|
      t.references :bill_lists, foreign_key: true
    end
  end
end
