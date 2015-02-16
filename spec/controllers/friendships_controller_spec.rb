require 'spec_helper'

describe FriendshipsController do 
  let(:user)   { create(:user) }
  let(:friend) { create(:user, first_name: "Friend") }

  before(:each) do
   sign_in user
   request.env["HTTP_REFERER"] = "/" unless request.nil? or request.env.nil?
 end

  describe "creating a friendship" do
    context "without Ajax" do 
      it "increments the Friendship count" do 
        expect { post :create, friended_id: friend.id }.
               to change{Friendship.count}.by(1)
      end
      it "increments the Notification count" do 
        expect { post :create, friended_id: friend.id }.
               to change{Notification.count}.by(1)
      end
    end
    context "with Ajax" do 
      it "increments the Friendship count" do 
        expect { xhr :post, :create, friended_id: friend.id }.
               to change{Friendship.count}.by(1)
      end
      it "increments the Notification count" do 
        expect { xhr :post, :create, friended_id: friend.id }.
               to change{Notification.count}.by(1)
      end
      it "responds with success" do 
        xhr :post, :create, friended_id: friend.id
        expect(response).to be_success
      end
    end
  end

  describe "updating a friendship" do
    before(:each) do 
      friend.send_friend_request_to(user)
    end
    let(:friendship) do
      friend.friendships.find_by(friended_id: user.id, accepted: false)
    end
    
    context "without Ajax" do 
      it "updates friendship accepted to true" do 
        patch :update, id: friendship.id
        expect(friendship.reload.accepted).to be_true
      end
    end
    context "with Ajax" do 
      it "updates friendship accepted to true" do 
        xhr :patch, :update, id: friendship.id
        expect(friendship.reload.accepted).to be_true
      end
      it "responds with success" do 
        xhr :patch, :update, id: friendship.id
        expect(response).to be_success
      end
    end
  end

  describe "destroying a friendship" do
    before(:each) do 
      user.send_friend_request_to(friend)
      friend.accept_friend_request_from(user)
    end
    let(:friendship) { Friendship.first }

    context "without Ajax" do 
      it "decrements the Friendship count" do 
        expect { delete :destroy, id: friendship.id, user_id: friend.id, 
                 unfriend: true }.to change{Friendship.count}.by(-1)
      end
    end
    context "with Ajax" do 
      it "decrements the Friendship count" do 
        expect { xhr :delete, :destroy, id: friendship.id, user_id: friend.id,
                 unfriend: true }.to change{Friendship.count}.by(-1)
      end
      it "responds with success" do 
        xhr :delete, :destroy, id: friendship.id, user_id: friend.id, 
            unfriend: true
        expect(response).to be_success
      end
    end
  end
end
