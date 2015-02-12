require "spec_helper"

describe "User pages" do 
  subject { page }
  let(:user) { create(:user) }

  before(:each) do
    log_in(user)
  end

  describe "index" do 
    before(:each) do
      visit users_path
    end

    it { should have_text("All Users") }

    context "with multiple users" do
        let(:friender)  { create(:user, first_name: "friender") }
        let(:friended)  { create(:user, first_name: "friended") }
        let(:no_friend) { create(:user, first_name: "no_friend") }

      before(:each) do
        friender  = create(:user, first_name: "friender")
        friended  = create(:user, first_name: "friended")
        no_friend = create(:user, first_name: "no_friend")
        visit users_path
      end

      it "does not list current user" do
        expect(page).not_to have_text(user.first_name)
      end
      it "lists all other users" do  
        expect(page).to have_text(friender.first_name)
        expect(page).to have_text(friended.first_name)
        expect(page).to have_text(no_friend.first_name)
      end
    end

    describe "friend management" do 
      let(:other_user) { create(:user, first_name: "other") }
      before(:each) do 
        other_user = create(:user, first_name: "other")
        visit users_path
      end

      it "sends friend request" do 
        click_on "Add Friend"
        expect(page).to have_text("Friend Request Sent")
      end
      it "accepts friend request" do 
        other_user.send_friend_request_to(user)
        visit users_path
        click_on "Accept"
        expect(page).to have_submit("Unfriend")
      end
      it "rejects friend request" do 
        other_user.send_friend_request_to(user)
        visit users_path
        click_on "Decline"
        expect(page).to have_submit("Add Friend")
      end
      it "unfriends" do
        other_user.send_friend_request_to(user)
        visit users_path
        click_on "Accept"
        click_on "Unfriend"
        expect(page).to have_submit("Add Friend")
      end
    end
  end

  describe "newsfeed" do

    it { should have_text("Newsfeed") }
    it { should have_text(user.first_name) }

    it "should match user" do 
      expect(user.first_name).to eq("John")
    end
  end
end
