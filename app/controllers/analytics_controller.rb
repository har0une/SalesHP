class AnalyticsController < ApplicationController
  def index
    @user = User.first
    @all_sales = SalesEntry.joins(goal: :user).where(users: { id: @user.id }).active

    # Time-based revenue records
    @revenue_today = @all_sales.where('sales_entries.created_at >= ?', Time.current.beginning_of_day).sum(:amount)
    @revenue_week  = @all_sales.where('sales_entries.created_at >= ?', Time.current.beginning_of_week).sum(:amount)
    @revenue_month = @all_sales.where('sales_entries.created_at >= ?', Time.current.beginning_of_month).sum(:amount)
    @revenue_year  = @all_sales.where('sales_entries.created_at >= ?', Time.current.beginning_of_year).sum(:amount)
    @revenue_total = @all_sales.sum(:amount)

    # For the table
    @recent_records = @all_sales.order(created_at: :desc).limit(50)
  end
end
