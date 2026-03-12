module SalesHp
  class GoalBrain
    def initialize(goal)
      @goal = goal
      @active_sales = goal.sales_entries.active
      @total_revenue = @active_sales.sum(:amount)
    end

    # The Center Gauge on your Dashboard (0-100%)
    def success_probability
      return 0 if days_remaining <= 0
      return 100 if @total_revenue >= @goal.target_amount

      # Calculation: Actual Velocity vs. Required Velocity
      # If ratio is 1.0, you are exactly on track.
      ratio = current_velocity / baseline_required_velocity
      
      # We cap it at 100 and floor it at 0
      [(ratio * 100).to_i, 100].min
    end

    # Progress Variance: How much ahead or behind (%)?
    def progress_variance_pct
      return 0 if expected_revenue_today == 0
      (((@total_revenue - expected_revenue_today) / expected_revenue_today) * 100).to_i
    end

    # The amount the user *should* have made by now to be on track
    def expected_revenue_today
      baseline_required_velocity * days_elapsed
    end

    # Predictive Projection: Projected final revenue at current pace
    def projected_total_revenue
      current_velocity * total_days
    end

    # Estimated goal completion percentage (e.g., 121%)
    def projected_completion_pct
      ((projected_total_revenue / @goal.target_amount) * 100).to_i
    end

    # The "Velocity Badge" (e.g., 1.4x)
    def velocity_multiplier
      return 0.0 if days_elapsed == 0
      (current_velocity / baseline_required_velocity).round(2)
    end

    # The "Recovery Vector" - How much do I need per day starting NOW?
    def required_daily_recovery
      return 0 if days_remaining <= 0
      remaining_balance = @goal.target_amount - @total_revenue
      (remaining_balance / days_remaining).round(2)
    end

    private

    def total_days
      [(@goal.deadline - @goal.start_date).to_i, 1].max
    end

    def days_elapsed
      [(Date.today - @goal.start_date.to_date).to_i, 0].max
    end

    def days_remaining
      [(@goal.deadline - Date.today).to_i, 0].max
    end

    def current_velocity
      return 0.0 if days_elapsed == 0
      @total_revenue.to_f / days_elapsed
    end

    def baseline_required_velocity
      @goal.target_amount.to_f / total_days
    end
  end
end
