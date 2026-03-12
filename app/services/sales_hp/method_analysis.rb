module SalesHp
  class MethodAnalysis
    def initialize(active_sales)
      @active_sales = active_sales
      @total_revenue = @active_sales.sum(:amount)
    end

    def method_effectiveness
      # We group by method and calculate revenue and deal count
      stats = @active_sales.group(:method).sum(:amount)
      counts = @active_sales.group(:method).count

      stats.map do |method, revenue|
        deal_count = counts[method] || 0
        {
          name: method.to_s.titleize,
          revenue: revenue,
          deals: deal_count,
          percentage: @total_revenue > 0 ? (revenue / @total_revenue.to_f * 100).to_i : 0,
          avg_deal: deal_count > 0 ? (revenue / deal_count.to_f).to_i : 0
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
