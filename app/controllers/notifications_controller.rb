class NotificationsController < ApplicationController
  layout "layouts/users"

  def index
    @notifications = current_user.notifications
    current_user.reset_new_notifications
  end
end
