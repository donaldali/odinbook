require "spec_helper"

describe User do
  let(:user) { create(:user) }
  subject { user }

  it { should be_valid }
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:gender) }
  it { should respond_to(:genderize) }
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
  it { should respond_to(:profile) }

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
    it { should have_one(:profile).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:gender) }
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
        expect{user.send_friend_request_to(friended)}.
               to change{Friendship.count}.by(1)
        expect{friended.send_friend_request_to(user)}.
               not_to change{Friendship.count}
      end
      it "doesn't send friend request to friends" do 
        make_friends(user, friended)
        expect{friended.send_friend_request_to(user)}.
               not_to change{Friendship.count}
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
      before { make_friends(user, friended) }

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
          not_friend = create(:user)
          non_friends = user.no_friendship
          expect(non_friends.count).to eq(1)
          expect(non_friends).to include(not_friend)
        end
      end
    end
  end

  describe "creates profile" do 
    it "makes a profile when a User is created" do
      new_user = create(:user)
      expect(new_user.profile.access_to).to eq(ACCESS[:all])
      expect(new_user.profile.email_notification).to be_true
    end
  end

  describe ".name" do 
    it "gets the combined name of a user" do 
      expect(user.name).to eq("#{user.first_name} #{user.last_name}")
    end
  end

  describe ".genderize" do
    it "genderizes a male" do
      expect(user.genderize).to eq("his")
    end
    it "genderizes a female" do
      expect(create(:user, gender: "female").genderize).to eq("her")
    end
  end

  describe "#unused_email?" do
    it "recognizes a used email" do
      expect(User.unused_email?(user.email)).to be_false
    end
    it "recognizes an unused email" do
      expect(User.unused_email?("unused@email.com")).to be_true
    end
  end

  describe ".timeline_feed" do
    let(:friend) { create(:user) }
    before { make_friends(user, friend) }

    it "includes posts created by user" do
      post = create(:post, creator: user, receiver: friend)
      expect(user.timeline_feed).to include(post)
    end
    it "includes posts received by user" do
      post = create(:post, creator: friend, receiver: user)
      expect(user.timeline_feed).to include(post)
    end
    it "doesn't duplicate user's post" do
      post = create(:post, creator: user, receiver: user)
      feed = user.timeline_feed
      expect(feed).to include(post)
      expect(feed.length).to eq(1)
    end
    it "doesn't include posts not created by or received by user" do
      non_friend = create(:user)
      make_friends(friend, non_friend)

      post = create(:post, creator: friend, receiver: non_friend)
      expect(user.timeline_feed).not_to include(post)
    end
  end

  describe ".newsfeed_feed" do
    let(:friend)     { create(:user) }
    let(:non_friend) { create(:user) }
    before(:each) do
      make_friends(user,   friend)
      make_friends(friend, non_friend)
    end

    it "includes posts created by user" do
      post = create(:post, creator: user, receiver: friend)
      expect(user.newsfeed_feed).to include(post)
    end
    it "includes posts received by user" do
      post = create(:post, creator: friend, receiver: user)
      expect(user.newsfeed_feed).to include(post)
    end
    it "doesn't duplicate user's post" do
      post = create(:post, creator: user, receiver: user)
      feed = user.newsfeed_feed
      expect(feed).to include(post)
      expect(feed.length).to eq(1)
    end
    it "includes posts created by user's friends" do
      post = create(:post, creator: friend, receiver: non_friend)
      expect(user.newsfeed_feed).to include(post)
    end
    it "includes posts received by user's friends" do
      post = create(:post, creator: non_friend, receiver: friend)
      expect(user.newsfeed_feed).to include(post)
    end
    it "doesn't duplicate user's friend's post" do
      post = create(:post, creator: friend, receiver: friend)
      feed = user.newsfeed_feed
      expect(feed).to include(post)
      expect(feed.length).to eq(1)
    end
    it "doesn't include posts not created by or for user or user's friends" do
      non_friend2 = create(:user)
      make_friends(non_friend, non_friend2)

      post = create(:post, creator: non_friend, receiver: non_friend2)
      expect(user.newsfeed_feed).not_to include(post)
    end
  end

  describe "#search" do
    let(:friend)   { create(:user, first_name: "friend") }
    let(:friender) { create(:user, first_name: "friender") }
    let(:friended) { create(:user, last_name: "friended") }
    let(:other)    { create(:user) }
    let(:result)   { User.search("FRIEND") }

    it "finds matching name, case insensitive" do
      expect(result).to include(friend)
    end
    it "finds similar first name, case insensitive" do
      expect(result).to include(friender)
    end
    it "finds similar last name, case insensitive" do
      expect(result).to include(friended)
    end
    it "doesn't find unrelated name" do
      expect(result).not_to include(other)
    end
  end
end
