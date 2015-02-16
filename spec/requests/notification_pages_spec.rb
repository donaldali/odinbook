require 'spec_helper'

describe 'Notification pages' do 
  let(:user) { create(:user) }
  let(:friender) { create(:user, first_name: "Friender") }
  subject { page }

  before { log_in(user) }

  describe 'index' do 
    before {
      friender.send_friend_request_to(user)
      Notification.send_notification(user, "request", friender.name)
    }
    it "shows new notification count" do 
      visit friends_path(user)
      expect(page).to have_selector("#new-notifications", text: "1")
    end
    it "shows notification" do 
      visit notifications_path
      expect(page).to have_text("Friender Doe sent you a Friend Request")
    end
    it "clears new notifications count" do
      visit notifications_path
      visit friends_path(user)
      expect(page).not_to have_selector("#new-notifications")
    end

  end
end
