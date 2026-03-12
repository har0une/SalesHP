module SalesHp
  class MethodAnalysis
    def initialize(goal)
      @goal = goal
      @active_sales = goal.sales_entries.active
      @total_revenue = @active_sales.sum(:amount)
    end

    def method_effectiveness
      # We group by method and calculate revenue and deal count
      @active_sales.group(:method).select(
        'method',
        'SUM(amount) as total_amount',
        'COUNT(*) as deal_count'
      ).map do |stat|
        {
          name: stat.method,
          revenue: stat.total_amount,
          deals: stat.deal_count,
          percentage: @total_revenue > 0 ? (stat.total_amount / @total_revenue.to_f * 100).to_i : 0,
          avg_deal: stat.deal_count > 0 ? (stat.total_amount / stat.deal_count.to_f).to_i : 0
        }
      end
    end

    def top_method
      method_effectiveness.max_by { |m| m[:revenue] }
    end

    def recommendation
      return "Log more sales to generate strategy insights." if @active_sales.count < 3
      
      top = top_method
      return "Current method alignment is balanced." unless top

      if top[:name] == 'referral'
        "Referral-based sales generate #{top[:percentage]}% of your revenue. Increasing referral outreach may accelerate your goal completion."
      else
        "Direct outreach is your primary driver at #{top[:percentage]}%. Consider scaling this channel to maintain velocity."
      end
    end
  end
end
