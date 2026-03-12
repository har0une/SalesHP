class GoalsController < ApplicationController
  def index
    @active_missions = @user.goals.where(active: true).where.not(title: "General Sales Ledger").order(created_at: :desc)
    @all_sales = SalesEntry.joins(goal: :user).where(users: { id: @user.id }).active.order(created_at: :desc)
    
    # Ledger pagination
    @pagy, @records = pagy(@all_sales, items: 20) rescue [nil, @all_sales]
  end

  def create
    @goal = @user.goals.new(goal_params)
    @goal.active = true
    @goal.start_date ||= Date.today
    
    if @goal.save
      redirect_to goals_path, notice: "New Mission Initialized! Strategy Engine engaged."
    else
      redirect_to goals_path, alert: "Failed to initialize mission: #{@goal.errors.full_messages.join(', ')}"
    end
  end

  def update
    @goal = @user.goals.find(params[:id])
    if @goal.update(active: false)
      redirect_to goals_path, notice: "Mission archived successfully."
    else
      redirect_to goals_path, alert: "Failed to update mission."
    end
  end

  private

  def goal_params
    params.require(:goal).permit(:title, :target_amount, :start_date, :deadline)
  end
end
