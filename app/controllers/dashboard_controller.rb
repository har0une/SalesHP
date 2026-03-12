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

    if @goal
      # Performance Engine (Level 3)
      @brain = SalesHp::GoalBrain.new(@goal)
      @method_analysis = SalesHp::MethodAnalysis.new(@goal)
      @mission_brain = SalesHp::MissionBrain.new(@goal, @brain)
      
      @probability = @brain.success_probability
      @velocity = @brain.velocity_multiplier
      @recovery_daily = @brain.required_daily_recovery
      @projected_revenue = @brain.projected_total_revenue
      @projected_pct = @brain.projected_completion_pct
      @variance = @brain.progress_variance_pct
      @effectiveness = @method_analysis.method_effectiveness
      @recommendation = @method_analysis.recommendation
      @mission = @mission_brain.current_mission
      @recent_sales = @goal.sales_entries.active.order(created_at: :desc).limit(5)
    else
      # Simple Mode (Level 1)
      @probability = 0
      @velocity = 1.0
      @recovery_daily = 0
      @projected_revenue = 0
      @projected_pct = 0
      @variance = 0
      @effectiveness = []
      @recommendation = "Enable a target goal to unlock professional strategy insights."
      @mission = nil # No missions without goals
      @recent_sales = @all_user_sales.order(created_at: :desc).limit(5)
    end
  end
end

