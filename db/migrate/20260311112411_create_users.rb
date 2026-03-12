class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email
      t.integer :total_xp
      t.integer :current_streak
      t.string :rank
      t.string :industry

      t.timestamps
    end
  end
end
