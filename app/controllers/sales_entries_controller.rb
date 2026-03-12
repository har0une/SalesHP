class SalesEntriesController < ApplicationController
  def create
    # Use the @goal set by the application controller, or fallback to master_ledger if params are weird
    target_goal = if params[:sales_entry][:goal_id].present?
                    @user.goals.find(params[:sales_entry][:goal_id])
                  else
                    @goal
                  end

    @sales_entry = target_goal.sales_entries.new(sales_entry_params)

    if @sales_entry.save
      redirect_to root_path, notice: "Sale tracked successfully! +#{@sales_entry.xp_earned} XP"
    else
      # For now, we'll just redirect back with an alert since it's a "Quick Log"
      redirect_to root_path, alert: "Failed to track sale: #{@sales_entry.errors.full_messages.join(', ')}"
    end
  end

  def update
    @sales_entry = SalesEntry.find(params[:id])
    if @sales_entry.update(status: :voided)
      redirect_to root_path, notice: "Sale voided. XP updated."
    else
      redirect_to root_path, alert: "Failed to void sale."
    end
  end

  private

  def sales_entry_params
    params.require(:sales_entry).permit(:amount, :method, :goal_id)
  end
end
