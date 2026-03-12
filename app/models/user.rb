class User < ApplicationRecord
  has_many :goals

  def current_streak
    streak = 0
    date = Date.today
    
    loop do
      sales_count = goals.joins(:sales_entries)
                         .where(sales_entries: { status: :active })
                         .where('DATE(sales_entries.created_at) = ?', date)
                         .count
      
      if sales_count > 0
        streak += 1
        date -= 1.day
      else
        # If it's today and no sales yet, don't break the streak unless yesterday was also empty
        if date == Date.today
          date -= 1.day
          next
        else
          break
        end
      end
    end
    
    streak
  end

  def average_revenue_during_streak
    days = current_streak
    return 0 if days == 0
    
    start_date = days.days.ago.to_date
    total_revenue = goals.joins(:sales_entries)
                         .where(sales_entries: { status: :active })
                         .where('sales_entries.created_at >= ?', start_date)
                         .sum(:amount)
    
    (total_revenue / days.to_f).to_i
  end

  def next_rank_name
    case rank
    when "Beginner Seller" then "Active Seller"
    when "Active Seller" then "Consistent Closer"
    when "Consistent Closer" then "Elite Seller"
    when "Elite Seller" then "Sales Champion"
    else "Legend"
    end
  end

  def next_rank_xp_threshold
    case rank
    when "Beginner Seller" then 1000
    when "Active Seller" then 5000
    when "Consistent Closer" then 15000
    when "Elite Seller" then 50000
    else total_xp # Maxed out
    end
  end

  def xp_progress_pct
    current_tier_start = case rank
                        when "Active Seller" then 1000
                        when "Consistent Closer" then 5000
                        when "Elite Seller" then 15000
                        when "Sales Champion" then 50000
                        else 0
                        end
    
    target = next_rank_xp_threshold
    return 100 if target == total_xp
    
    ((total_xp - current_tier_start).to_f / (target - current_tier_start) * 100).to_i
  end

  def update_rank!
    new_rank = case total_xp
               when 0..999 then "Beginner Seller"
               when 1000..4999 then "Active Seller"
               when 5000..14999 then "Consistent Closer"
               when 15000..49999 then "Elite Seller"
               else "Sales Champion"
               end
    update(rank: new_rank) if rank != new_rank
  end
end
