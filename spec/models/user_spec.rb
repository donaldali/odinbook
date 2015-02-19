require "spec_helper"

describe User do
  let(:user) { create(:user) }
  subject { user }

  it { should be_valid }
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:friendships) }
  it { should respond_to(:friended_users) }
  it { should respond_to(:reverse_friendships) }
  it { should respond_to(:frienders) }
  it { should respond_to(:send_friend_request_to) }
  it { should respond_to(:accept_friend_request_from) }
  it { should respond_to(:reject_friend_request_from) }
  it { should respond_to(:unfriend) }
  it { should respond_to(:has_friend_request_from?) }
  it { should respond_to(:friends_with?) }
  it { should respond_to(:friends) }
  it { should respond_to(:requests_from) }
  it { should respond_to(:no_friendship) }
  it { should respond_to(:name) }
  it { should respond_to(:notifications) }
  it { should respond_to(:new_notifications) }
  it { should respond_to(:reset_new_notifications) }
  it { should respond_to(:update_new_notifications) }
  it { should respond_to(:new_notifications?) }
  it { should respond_to(:created_posts) }
  it { should respond_to(:received_posts) }
  it { should respond_to(:comments) }
  it { should respond_to(:likes) }

  describe "associations" do 
    it { should have_many(:friendships).dependent(:destroy) }
    it { should have_many(:friended_users) }
    it { should have_many(:reverse_friendships).dependent(:destroy) }
    it { should have_many(:frienders) }
    it { should have_many(:notifications).dependent(:destroy) }
    it { should have_many(:created_posts).dependent(:destroy) }
    it { should have_many(:received_posts).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should allow_value("foo@example.com").for(:email) }
    it { should_not allow_value("foo@example").for(:email) }
    it { should_not allow_value("@example.com").for(:email) }
  end

  describe "defaults" do
    it "sets new_notifications to zero" do
      expect(user.new_notifications).to be_zero
    end
  end

  describe "notifications management" do 
    before(:each) do 
      Notification.send_notification(user, "request", "Friender")
    end
    it "resets new notifications" do
      expect(user.new_notifications).to eq(1)
      user.reset_new_notifications
      expect(user.new_notifications).to be_zero
    end
    it "increases new notifications" do
      expect{ user.update_new_notifications }.
        to change{ user.new_notifications }.by(1)
    end
    it "checks for new notifications" do 
      expect(user.new_notifications?).to be_true
      user.reset_new_notifications
      expect(user.new_notifications?).to be_false
    end
  end
  
  describe "friending" do 
    let(:friended) { create(:user) }

    describe ".send_friend_request_to" do 
      it "sends friend request" do 
        user.send_friend_request_to(friended)
        expect(user.has_friend_request_from?(friended)).to be_false
        expect(friended.has_friend_request_from?(user)).to be_true
      end
      it "doesn't duplicate friend requests" do 
        expect{user.send_friend_request_to(friended)}.to change{Friendship.count}.by(1)
        expect{friended.send_friend_request_to(user)}.not_to change{Friendship.count}
      end
      it "doesn't send friend request to friends" do 
        make_friends(user, friended)
        expect{friended.send_friend_request_to(user)}.not_to change{Friendship.count}
      end
    end

    describe ".accept_friend_request_from" do 
      it "accepts friend request" do 
        make_friends(user, friended)
        expect(user.friends_with?(friended)).to be_true
        expect(friended.friends_with?(user)).to be_true
      end
    end

    describe ".reject_friend_request_from" do 
      it "rejects friend request" do 
        user.send_friend_request_to(friended)
        friended.reject_friend_request_from(user)
        expect(user.friends_with?(friended)).to be_false
        expect(friended.friends_with?(user)).to be_false
      end
    end

    describe ".unfriend" do 
      before do 
        make_friends(user, friended)
      end

      it "allows friender friend to unfriend" do 
        user.unfriend(friended)
        expect(user.friends_with?(friended)).to be_false
        expect(friended.friends_with?(user)).to be_false
      end
      it "allows friended friend to unfriend" do 
        friended.unfriend(user)
        expect(user.friends_with?(friended)).to be_false
        expect(friended.friends_with?(user)).to be_false
      end
    end

    describe ".friends" do 
      let(:friender) { create(:user) }

      it "gets all friends" do 
        make_friends(user, friended)
        make_friends(friender, user)
        expect(user.friends).to include(friended)
        expect(user.friends).to include(friender)
      end
    end

    describe "friend status" do
      let(:friender)     { create(:user) }
      let(:friend)       { create(:user) }
      let(:not_friend)   { create(:user) }

      before(:each) do
        friender.send_friend_request_to(user)
        user.send_friend_request_to(friended)
        make_friends(friend, user)
      end

      describe ".requests_from" do 
        it "gets users friend request came from" do 
          requesters = user.requests_from
          expect(requesters.count).to eq(1)
          expect(requesters).to include(friender)
        end
      end

      describe ".no_friendship" do 
        it "gets user with no friendship/request" do 
          non_friend = user.no_friendship
          expect(non_friend.count).to eq(1)
          expect(non_friend).to include(not_friend)
        end
      end
    end
  end

  describe ".name" do 
    it "gets the combined name of a user" do 
      expect(user.name).to eq("#{user.first_name} #{user.last_name}")
    end
  end
end
