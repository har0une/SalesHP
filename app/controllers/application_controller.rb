class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :set_user

  private

  def set_user
    @user = User.first
    @goal = @user.goals.active.last || @user.master_ledger
  end
end
