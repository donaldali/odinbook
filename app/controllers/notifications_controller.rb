class NotificationsController < ApplicationController
  layout "layouts/users"

  def index
    @notifications = current_user.notifications.limit(30).order(created_at: :desc)
    @new_count     = current_user.new_notifications
    current_user.reset_new_notifications
  end

  def update_new
  end
end
