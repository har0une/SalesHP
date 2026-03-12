class AddTitleToGoals < ActiveRecord::Migration[8.1]
  def change
    add_column :goals, :title, :string
  end
end
