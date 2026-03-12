class OrdersController < ApplicationController
  def index
    @user = User.first
    @all_sales = SalesEntry.joins(goal: :user).where(users: { id: @user.id }).active.order(created_at: :desc)
    
    # Filter by date if params provided (future-proofing)
    if params[:date].present?
      @all_sales = @all_sales.where('DATE(sales_entries.created_at) = ?', params[:date])
    end

    @pagy, @records = pagy(@all_sales, items: 20) rescue [nil, @all_sales]
  end
end
