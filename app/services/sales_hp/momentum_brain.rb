module SalesHp
  class MomentumBrain
    def initialize(user_sales)
      @user_sales = user_sales
      @this_week = user_sales.where('sales_entries.created_at >= ?', 7.days.ago.beginning_of_day)
      @last_week = user_sales.where(created_at: 14.days.ago.beginning_of_day..7.days.ago.end_of_day)
    end

    def growth_variance
      this_week_total = @this_week.sum(:amount)
      last_week_total = @last_week.sum(:amount)

      return 0 if last_week_total == 0
      (((this_week_total - last_week_total) / last_week_total.to_f) * 100).to_i
    end

    def momentum_velocity
      this_week_avg = @this_week.sum(:amount) / 7.0
      last_week_avg = @last_week.sum(:amount) / 7.0

      return 1.0 if last_week_avg == 0
      (this_week_avg / last_week_avg.to_f).round(2)
    end

    def projected_monthly_revenue
      # Based on current 7-day run rate
      (@this_week.sum(:amount) / 7.0) * 30
    end

    def status_label
      v = momentum_velocity
      if v >= 1.2 then "Accelerating"
      elsif v >= 0.9 then "Steady"
      else "Decelerating"
      end
    end

    def recommendation
      v = momentum_velocity
      if v >= 1.2
        "Momentum is high! Scale your current outreach channel."
      elsif v >= 0.9
        "Steady consistency. Focus on increasing average deal size."
      else
        "Momentum stall detected. Review your last week's sales channels."
      end
    end
  end
end
