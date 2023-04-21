class CreateStatements < ActiveRecord::Migration[5.1]
  def change
    create_table :statements do |t|
      t.references :bill, foreign_key: true

      t.timestamps
    end
  end
end
