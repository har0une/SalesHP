class UsersController < ApplicationController
  def update_methods
    @user = User.first
    new_methods = params[:methods].split(',').map(&:strip).reject(&:empty?).uniq
    
    if new_methods.any?
      @user.update(sales_methods: new_methods)
      redirect_back fallback_location: analytics_path, notice: "Sales profile updated successfully."
    else
      redirect_back fallback_location: analytics_path, alert: "You must have at least one sales method."
    end
  end
end
