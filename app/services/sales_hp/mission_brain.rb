module SalesHp
  class MissionBrain
    def initialize(goal, brain)
      @goal = goal
      @brain = brain
    end

    def current_mission
      if @brain.progress_variance_pct < -10
        {
          title: "System Recovery Protocol",
          description: "Critically low velocity detected. Adjust targeting to referral channels for immediate HP recovery.",
          type: :urgent,
          icon: "⚔️"
        }
      elsif @brain.progress_variance_pct < 0
        {
          title: "Velocity Maintenance",
          description: "Slight deficit detected. Increase activity to return to baseline trajectory.",
          type: :warning,
          icon: "⚠️"
        }
      else
        {
          title: "Ideal Velocity Maintained",
          description: "Your current strategic alignment is yielding peak XP. Keep this rhythm to reach Rank S.",
          type: :success,
          icon: "🧠"
        }
      end
    end

    def daily_target
      # Reward for 80% effort or recovery target
      @brain.required_daily_recovery > 0 ? @brain.required_daily_recovery : 0
    end
  end
end
