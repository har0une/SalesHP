class DashboardController < ApplicationController
  def index
    # For now, we take the first user (later we'll use current_user)
    @user = User.first 
    @goal = @user.goals.active.last
    
    if @goal
      # Initialize the "Brains"
      @brain = SalesHp::GoalBrain.new(@goal)
      @method_analysis = SalesHp::MethodAnalysis.new(@goal)
      @pattern_brain = SalesHp::PatternBrain.new(@goal)
      @mission_brain = SalesHp::MissionBrain.new(@goal, @brain)
      
      # Core Progress & Projections
      @probability = @brain.success_probability
      @velocity = @brain.velocity_multiplier
      @recovery_daily = @brain.required_daily_recovery
      @projected_revenue = @brain.projected_total_revenue
      @projected_pct = @brain.projected_completion_pct
      @variance = @brain.progress_variance_pct
      
      # Strategy & Method Effectiveness
      @effectiveness = @method_analysis.method_effectiveness
      @recommendation = @method_analysis.recommendation
      
      # Profile & Patterns
      @best_day = @pattern_brain.best_day
      @avg_deal = @pattern_brain.average_deal_size
      @strength = @pattern_brain.sales_strength
      
      # Daily Mission
      @mission = @mission_brain.current_mission
      
      @streak_avg = @user.average_revenue_during_streak
      
      @recent_sales = @goal.sales_entries.active.order(created_at: :desc).limit(5)
    else
      @probability = 0
      @velocity = 1.0
      @recovery_daily = 0
      @projected_revenue = 0
      @projected_pct = 0
      @variance = 0
      @effectiveness = []
      @recommendation = "Initialize a target goal to generate strategy insights."
      @best_day = "N/A"
      @avg_deal = 0
      @strength = "N/A"
      @mission = { title: "No Active Goal", description: "Set your first target mission to start learning patterns.", type: :neutral, icon: "🗺️" }
      @recent_sales = []
    end
  end
end

