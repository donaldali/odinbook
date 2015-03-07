require 'spec_helper'

describe 'Notification pages' do 
  let(:user) { create(:user) }
  let(:friender) { create(:user, first_name: "Friender") }
  subject { page }

  before { log_in(user) }

  describe 'index' do 
    before { friend_request_to_from(user, friender) }

    it "shows new notification count" do 
      expect(page).to have_selector("#new-notifications", text: "1")
    end

    describe "on page" do
      before { visit notifications_path }

      it { should have_title("Your Notifications") }
      it "shows notification" do 
        expect(page).to have_text("#{friender.name} sent you a Friend Request")
      end
      it "clears new notifications count" do
        expect(page).not_to have_selector("#new-notifications")
      end
    end

  end
end
