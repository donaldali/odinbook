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

    it { should have_selector("h1", text: "All Users") }

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

      it "lists current user" do
        within ".users-container" do
          expect(page).to have_text(user.first_name)
        end
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
        click_on "Confirm"
        expect(page).to have_submit("Unfriend")
      end
      it "rejects friend request" do 
        other_user.send_friend_request_to(user)
        visit users_path
        click_on "Delete Request"
        expect(page).to have_submit("Add Friend")
      end
      it "unfriends" do
        other_user.send_friend_request_to(user)
        visit users_path
        click_on "Confirm"
        click_on "Unfriend"
        expect(page).to have_submit("Add Friend")
      end
    end
  end

  describe "friendship status pages" do
    let(:friender1)  { create(:user, first_name: "friender1") }
    let(:friender2)  { create(:user, first_name: "friender2") }
    let(:friended1)  { create(:user, first_name: "friended1") }
    let(:friended2)  { create(:user, first_name: "friended2") }
    let(:friend1)    { create(:user, first_name: "friend1") }
    let(:friend2)    { create(:user, first_name: "friend2") }
    let(:no_friend1) { create(:user, first_name: "no_friend1") }
    let(:no_friend2) { create(:user, first_name: "no_friend2") }

    before(:each) do
      friender1  = create(:user, first_name: "friender1")
      friender2  = create(:user, first_name: "friender2")
      friended1  = create(:user, first_name: "friended1")
      friended2  = create(:user, first_name: "friended2")
      friend1    = create(:user, first_name: "friend1")
      friend2    = create(:user, first_name: "friend2")
      no_friend1 = create(:user, first_name: "no_friend1")
      no_friend1 = create(:user, first_name: "no_friend2")
      friender1.send_friend_request_to(user)
      friender2.send_friend_request_to(user)
      user.send_friend_request_to(friended1)
      user.send_friend_request_to(friended2)
      make_friends(user, friend1)
      make_friends(user, friend2)
    end

    describe "friends page" do 
      before(:each) { visit friends_path(user) }

      it "has the correct header" do 
        expect(page).to have_selector("h1", text: "Friends")
      end
      it "has the right number of friends" do
        expect(page).to have_submit("Unfriend", count: 2) 
      end
      it "displays the right number of friends" do 
        expect(page).to have_selector("#friend-count", text: "(2)")
      end
      it "lists all friends" do
        expect(page).to have_link(friend1.name)
        expect(page).to have_link(friend2.name)
      end

      context "when unfriending" do
        before(:each) do 
          click_on("Unfriend", match: :first)
        end

        it "removes only unfriended user" do
          expect(page).to have_submit("Unfriend", count: 1)
        end
        it "removes all info about unfriended user" do
          expect(page).to have_selector("li.user-container", count: 1)
        end
        it "updates the number of friends" do 
          expect(page).to have_selector("#friend-count", text: "(1)")
        end
        it "stays on the same page" do
          expect(current_path).to eq(friends_path(user))
        end
      end
    end

    describe "friend requests page" do 
      before(:each) { visit friend_requests_path(user) }

      it "has the correct header" do 
        expect(page).to have_selector("h1", text: "Friend Requests")
      end
      it "has the right number of friend requests" do
        expect(page).to have_submit("Confirm", count: 2)
      end
      it "lists all friend requests" do
        expect(page).to have_link(friender1.name)
        expect(page).to have_link(friender2.name)
      end

      context "accepting friend request" do
        before(:each) do 
          click_on("Confirm", match: :first)
        end

        it "removes only accepted user" do
          expect(page).to have_submit("Confirm", count: 1)
        end
        it "removes all info about accepted user" do
          expect(page).to have_selector(".user-container", count: 1)
        end
        it "updates the number of friends" do 
          expect(page).to have_selector("#friend-count", text: "(3)")
        end
        it "stays on the same page" do
          expect(current_path).to eq(friend_requests_path(user))
        end
      end

      context "rejecting friend request" do
        before(:each) do 
          click_on("Delete Request", match: :first)
        end

        it "removes only rejected user" do
          expect(page).to have_submit("Delete Request", count: 1)
        end
        it "removes all info about rejected user" do
          expect(page).to have_selector(".user-container", count: 1)
        end
        it "stays on the same page" do
          expect(current_path).to eq(friend_requests_path(user))
        end
      end
    end

    describe "find friends page" do 
      before(:each) { visit find_friends_path(user) }

      it "has the correct header" do 
        expect(page).to have_selector("h1", text: "Find Friends")
      end
      it "has the right number of friends" do
        expect(page).to have_submit("Add Friend", count: 2)
      end
      it "lists all non-friends/requests" do
        expect(page).to have_link(friend1.name)
        expect(page).to have_link(friend2.name)
      end

      context "when friending" do
        before(:each) do 
          click_on("Add Friend", match: :first)
        end

        it "removes only friended user" do
          expect(page).to have_submit("Add Friend", count: 1)
        end
        it "removes all info about friended user" do
          expect(page).to have_selector(".user-container", count: 1)
        end
        it "stays on the same page" do
          expect(current_path).to eq(find_friends_path(user))
        end
      end
    end

  end

  describe "newsfeed" do

    describe "post creation" do 
      before { visit newsfeed_path(user) }

      it { should have_selector(".post-form") }
      it { should have_text("Update status") }
      it { should have_button("Post") }

      context "with no post content" do
        it "does not create a post" do
          expect { click_on "Post" }.not_to change{ Post.count }
        end
      end

      context "with post content" do
        before { fill_in "Update status", with: "Lorem ipsum post" }

        it "creates a post" do
          expect { click_on "Post" }.to change{ Post.count }.by(1)
        end
        it "displays the post" do 
          click_on "Post"
          expect(page).to have_text("Lorem ipsum post")
        end
        it "displays the post's creator" do 
          click_on "Post"
          within ".newsfeed-container" do 
            expect(page).to have_text(user.name)
          end
        end
      end
    end

    describe "post deletion" do
      before do 
        visit newsfeed_path(user)
        fill_in "Update status", with: "Lorem ipsum post"
        click_on "Post"
      end
      it "allows deletion of own post" do
        expect{ page.first(".delete").click }.to change{ Post.count }.by(-1)
      end
    end

    describe "comment creation" do 
      before do 
        visit newsfeed_path(user)
        fill_in "Update status", with: "Lorem ipsum"
        click_on "Post"
      end

      context "with no comment content" do 
        it "does not create a comment" do
          expect { click_button "Comment" }.not_to change{ Comment.count }
        end
      end

      context "with comment content" do 
        before do 
          within('.post-container') do 
            fill_in "Content", with: "Lorem ipsum comment"
          end
        end

        it "creates a comment" do
          expect { click_button "Comment" }.to change{ Comment.count }.by(1)
        end
        it "displays the comment" do 
          click_button "Comment"
          expect(page).to have_text("Lorem ipsum comment")
        end
        it "displays the commenter's name" do 
          click_button "Comment"
          within ".post-container" do 
            expect(page).to have_text(user.name)
          end
        end
      end
    end

    describe "comment deletion" do
      before do 
        visit newsfeed_path(user)
        fill_in "Update status", with: "Lorem ipsum post"
        click_on "Post"
        within('.post-container') do 
          fill_in "Content", with: "Lorem ipsum comment"
          click_button "Comment"
        end
      end
      it "allows deletion of own comment" do
        expect{ page.find(".comment-container").find(".delete").click }.
                to change{ Comment.count }.by(-1)
      end
    end

    describe "liking a post" do 
      before do 
        visit newsfeed_path(user)
        fill_in "Update status", with: "Lorem ipsum"
        click_on "Post"
      end

      it "creates a like" do 
        expect { click_on "Like" }.to change{ Like.count }.by(1)
      end
      it "enables unliking" do
        click_on "Like"
        expect(page).to have_link("Unlike")
      end
      it "can unlike" do 
        click_on "Like"
        expect { click_on "Unlike" }.to change{ Like.count }.by(-1)
      end
    end

    describe "liking a comment" do 
      before do 
        visit newsfeed_path(user)
        fill_in "Update status", with: "Lorem ipsum"
        click_on "Post"
        visit newsfeed_path(user)
        within '.comment-form' do 
          fill_in "Content", with: "Lorem"
          click_on "Comment"
        end
      end

      it "creates a like" do 
        within '.comment-container' do 
          expect { click_on "Like" }.to change{ Like.count }.by(1)
        end
      end
      it "enables unliking" do
        within '.comment-container' do 
          click_on "Like"
        end
          expect(page).to have_link("Unlike")
      end
      it "can unlike" do 
        within '.comment-container' do 
          click_on "Like"
        end
        expect { click_on "Unlike" }.to change{ Like.count }.by(-1)
      end
    end

  end

  describe "Timeline" do 
    context "for current user" do 
      before { visit timeline_path(user) }

      it { should have_css(".profile") }
      it { should have_xpath("//img[@class='v-lg-img']") }
      it { should have_selector(".post-form") }
      it { should have_text("Status") }
      it { should have_button("Post") }

      it "has link to Timeline" do
        expect(find(".profile")).to have_link("Timeline")
      end
      it "has link to About" do
        expect(find(".profile")).to have_link("About")
      end
      it "has link to friends" do
        expect(find(".profile")).to have_link("Friends")
      end
      it "has display for friend status" do
        expect(find(".profile")).to have_css(".friend-status")
      end

      context "as friend status" do
        let(:friender)  { create(:user, first_name: "friender") }
        let(:friended)  { create(:user, first_name: "friended") }
        let(:friend)    { create(:user, first_name: "friend") }
        let(:no_friend) { create(:user, first_name: "no_friend") }

        context "for the current user" do
          it "displays correct friend status" do
            visit timeline_path(user)
            expect(find(".friend-status")).
                   to have_link("Update your Profile")
          end
        end

        context "for a friender" do
          it "displays correct friend status" do
            friend_request_to_from(user, friender)
            visit timeline_path(friender)
            expect(find(".friend-status")).
                   to have_text("Friend request from #{friender.first_name}")
            expect(find(".friend-status")).
                   to have_link("See your friend requests")
          end
        end

        context "for a friended" do
          it "displays correct friend status" do
            friend_request_from_to(user, friended)
            visit timeline_path(friended)
            expect(find(".friend-status")).
                   to have_text("Friend request pending")
          end
        end

        context "for a friend" do
          it "displays correct friend status" do
            make_friends2(user, friend)
            visit timeline_path(friend)
            expect(find(".friend-status")).
                   to have_text("Friends with #{friend.first_name}")
          end
        end

        context "for a non-friend" do
          before { visit timeline_path(no_friend) }

          it "displays correct friend status" do
            expect(find(".friend-status")).
                   to have_text("Do you know #{no_friend.first_name}?")
            expect(find(".friend-status")).
                   to have_submit("Add Friend")
          end
          it "allows friend request to be sent" do
            friendships = Friendship.count
            within(".friend-status") { click_on("Add Friend") }
            expect(Friendship.count).to eq(friendships + 1)
          end
          it "displays correct status after sending friend request" do
            within(".friend-status") { click_on("Add Friend") }
            expect(find(".friend-status")).
                   to have_text("Friend request pending")
          end
        end
      end

      describe "display of post comment like" do
        before(:each) do
          make_post_comment_likes(user, user)
          visit timeline_path(user)
        end

        it "includes post form" do
          expect(page).to have_selector('.post-form')
        end
        it "includes posts" do
          expect(page).to have_selector('#posts')
        end
        it "includes post delete button" do
          expect(find('.post-details')).to have_selector('.delete')
        end
        it "includes post unlike" do
          expect(find('.post-details')).to have_link('Unlike')
        end
        it "includes comment link" do
          expect(find('.post-details')).to have_link('Comment')
        end
        it "includes the post's likes" do
          expect(page).to have_text('You like this')
        end
        it "includes comment delete button" do
          expect(find('.comment-details')).to have_selector('.delete')
        end
        it "includes comment unlike" do
          expect(find('.comment-details')).to have_link('Unlike')
        end
        it "includes count of comment's likes" do
          expect(find('.comment-details')).to have_text('1')
        end
        it "includes comment form" do
          expect(page).to have_selector('.comment-form')
        end
      end
    end

    context "for friends" do 
      let(:friend) { create(:user) }
      before(:each) do 
        make_friends2(user, friend)
        visit timeline_path(friend)
      end

      it { should have_css(".profile") }
      it { should have_xpath("//img[@class='v-lg-img']") }
      it { should have_selector(".post-form") }
      it { should have_button("Post") }

      it "has form label for posts" do
        expect(find(".post-label")).to have_text("Post")
      end
      it "has display for friend status" do
        expect(find(".profile")).to have_css(".friend-status")
      end
      it "has link to Timeline" do
        expect(find(".profile")).to have_link("Timeline")
      end
      it "has link to About" do
        expect(find(".profile")).to have_link("About")
      end
      it "has link to friends" do
        expect(find(".profile")).to have_link("Friends")
      end

      describe "display of post comment like" do
        before(:each) do
          make_post_comment_likes(user, friend)
          visit timeline_path(friend)
        end

        it "includes post form" do
          expect(page).to have_selector('.post-form')
        end
        it "includes posts" do
          expect(page).to have_selector('#posts')
        end
        it "doesn't include post delete button" do
          expect(find('.post-details')).not_to have_selector('.delete')
        end
        it "includes post like" do
          expect(find('.post-details')).to have_link('Like')
        end
        it "includes comment link" do
          expect(find('.post-details')).to have_link('Comment')
        end
        it "includes the post's likes" do
          expect(page).to have_text('1 person likes this')
        end
        it "doesn't include comment delete button" do
          expect(find('.comment-details')).not_to have_selector('.delete')
        end
        it "includes comment like" do
          expect(find('.comment-details')).to have_link('Like')
        end
        it "includes count of comment's likes" do
          expect(find('.comment-details')).to have_text('1')
        end
        it "includes comment form" do
          expect(page).to have_selector('.comment-form')
        end
      end
    end

    context "for non-friends with public profile" do 
      let(:public_user) { create(:user) }
      before { visit timeline_path(public_user) }

      it { should have_css(".profile") }
      it { should have_xpath("//img[@class='v-lg-img']") }
      it { should_not have_selector(".post-form") }

      it "has display for friend status" do
        expect(find(".profile")).to have_css(".friend-status")
      end
      it "has link to Timeline" do
        expect(find(".profile")).to have_link("Timeline")
      end
      it "has link to About" do
        expect(find(".profile")).to have_link("About")
      end
      it "has link to friends" do
        expect(find(".profile")).to have_link("Friends")
      end

      describe "display of post comment like" do
        before(:each) do
          make_post_comment_likes(user, public_user)
          visit timeline_path(public_user)
        end

        it "doesn't include post form" do
          expect(page).not_to have_selector('.post-form')
        end
        it "includes posts" do
          expect(page).to have_selector('#posts')
        end
        it "doesn't include post delete button" do
          expect(find('.post-details')).not_to have_selector('.delete')
        end
        it "includes post like" do
          expect(find('.post-details')).to have_link('Like')
        end
        it "doesn't include comment link" do
          expect(find('.post-details')).not_to have_link('Comment')
        end
        it "includes the post's likes" do
          expect(page).to have_text('1 person likes this')
        end
        it "doesn't include comment delete button" do
          expect(find('.comment-details')).not_to have_selector('.delete')
        end
        it "includes comment like" do
          expect(find('.comment-details')).to have_link('Like')
        end
        it "includes count of comment's likes" do
          expect(find('.comment-details')).to have_text('1')
        end
        it "doesn't include comment form" do
          expect(page).not_to have_selector('.comment-form')
        end
      end
    end

    context "for non-friends with private profile" do 
      let(:private_user) { create(:user) }
      before do 
        make_user_private(user, private_user)
        visit timeline_path(private_user)
      end

      it { should have_css(".profile") }
      it { should have_xpath("//img[@class='v-lg-img']") }
      it { should_not have_selector(".post-form") }

      it "has display for friend status" do
        expect(find(".profile")).to have_css(".friend-status")
      end
      it "has link to Timeline" do
        expect(find(".profile")).to have_link("Timeline")
      end
      it "doesn't have link to About" do
        visit timeline_path(private_user)
        expect(find(".banner-bottom")).not_to have_link("About")
      end
      it "doesn't have link to friends" do
        expect(find(".profile")).not_to have_link("Friends")
      end

      describe "display of post comment like" do
        before(:each) do
          make_post_comment_likes(user, private_user)
          visit timeline_path(private_user)
        end

        it "doesn't includes post form" do
          expect(page).not_to have_selector('.post-form')
        end
        it "doesn't include posts" do
          expect(page).not_to have_selector('#posts')
        end

        it "has message about hidden content" do
          expect(page).to have_text("#{private_user.first_name} only " \
          "shares #{private_user.genderize} profile and posts with friends")
        end
      end
    end

  end
end
