class DashboardController < ApplicationController
  def index
    # For now, we take the first user (later we'll use current_user)
    @user = User.first 
    @goal = @user.goals.active.last
    
    # Base Stats (Always calculated across all user sales)
    @all_user_sales = SalesEntry.joins(goal: :user).where(users: { id: @user.id }).active
    @revenue_today = @all_user_sales.where('sales_entries.created_at >= ?', Time.current.beginning_of_day).sum(:amount)
    @revenue_week  = @all_user_sales.where('sales_entries.created_at >= ?', Time.current.beginning_of_week).sum(:amount)
    @revenue_month = @all_user_sales.where('sales_entries.created_at >= ?', Time.current.beginning_of_month).sum(:amount)
    @revenue_total = @all_user_sales.sum(:amount)

    # Initializing Global Patterns
    @global_patterns = SalesHp::PatternBrain.new(@all_user_sales)
    @best_day = @global_patterns.best_day
    @avg_deal = @global_patterns.average_deal_size
    @strength = @global_patterns.sales_strength
    @streak_avg = @user.average_revenue_during_streak

    # Momentum & strategy Engine (Global)
    @momentum = SalesHp::MomentumBrain.new(@all_user_sales)
    @method_analysis = SalesHp::MethodAnalysis.new(@all_user_sales)
    
    @velocity = @momentum.momentum_velocity
    @variance = @momentum.growth_variance
    @recommendation = @momentum.recommendation
    @status = @momentum.status_label
    
    @probability = 0
    @recovery_daily = 0
    @projected_revenue = @momentum.projected_monthly_revenue
    @projected_pct = (@variance > 0 ? @variance : 0) 
    @effectiveness = @method_analysis.method_effectiveness
    @mission = nil 
    @recent_sales = @all_user_sales.order(created_at: :desc).limit(5)
  end
end

