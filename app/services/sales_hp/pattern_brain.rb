module SalesHp
  class PatternBrain
    def initialize(goal_or_sales)
      if goal_or_sales.is_a?(ActiveRecord::Relation)
        @active_sales = goal_or_sales
      else
        @goal = goal_or_sales
        @active_sales = goal_or_sales.sales_entries.active
      end
    end

    def best_day
      day_stats = @active_sales.group("strftime('%w', sales_entries.created_at)").sum(:amount)
      best_day_num = day_stats.max_by { |_day, sum| sum }&.first
      return "N/A" unless best_day_num

      Date::DAYNAMES[best_day_num.to_i]
    end

    def average_deal_size
      return 0 if @active_sales.count == 0
      (@active_sales.sum(:amount) / @active_sales.count.to_f).to_i
    end

    def sales_strength
      top_method = @active_sales.group(:method).count.max_by { |_m, count| count }&.first
      case top_method
      when 'referral' then "Relationship Selling"
      when 'direct' then "Direct Outreach"
      else "Versatile Closer"
      end
    end
  end
end
