class CreateSalesEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :sales_entries do |t|
      t.references :goal, null: false, foreign_key: true
      
      # 1. High-Ticket Precision: Handle ₦50M+ without rounding errors
      t.decimal :amount, precision: 15, scale: 2, null: false
      
      t.string :method # referral, cold_call, social_media
      t.integer :xp_earned, default: 0
      t.datetime :entry_date, default: -> { 'CURRENT_TIMESTAMP' }
      
      # 2. Strict Correction: Default to active (0) so we can void (1) later
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
