class CreateGoals < ActiveRecord::Migration[8.1]
  def change
    create_table :goals do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :target_amount
      t.date :deadline
      t.date :start_date
      t.boolean :active

      t.timestamps
    end
  end
end
