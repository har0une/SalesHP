class AddSalesMethodsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :sales_methods, :text
  end
end
