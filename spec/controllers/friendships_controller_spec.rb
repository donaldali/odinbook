require 'spec_helper'

describe FriendshipsController do 
  let(:user)       { create(:user) }
  let(:friend)     { create(:user) }
  let(:non_friend) { create(:user) }

  before(:each) do
    sign_in user
    unless request.nil? or request.env.nil?
      request.env["HTTP_REFERER"] = user_root_path(user)
    end 
  end

  describe "POST create" do
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

  describe "PATCH update" do
    context "without Ajax" do 
      let(:friendship) { create(:friendship, friender: friend, 
                                 friended: user, accepted: false) }

      it "updates friendship accepted to true" do 
        patch :update, id: friendship.id
        expect(friendship.reload.accepted).to be_true
      end
    end

    context "with Ajax" do 
      context "when current user is friended" do
        let(:friendship) { create(:friendship, friender: friend, 
                                   friended: user, accepted: false) }

        it "updates friendship accepted to true" do 
          xhr :patch, :update, id: friendship.id
          expect(friendship.reload.accepted).to be_true
        end
        it "responds with success" do 
          xhr :patch, :update, id: friendship.id
          expect(response).to be_success
        end
      end

      context "when current user is friender" do
        let(:friendship) { create(:friendship, friender: user, 
                               friended: friend, accepted: false) }

        it "shows flash with denied message" do
          xhr :patch, :update, id: friendship.id
          expect(flash[:alert]).to include("Access denied.")
        end
        it "redirects" do
          xhr :patch, :update, id: friendship.id
          expect(response.status).to eq(302)
        end
        it "redirects to current user's root path" do
          xhr :patch, :update, id: friendship.id
          expect(response).to redirect_to(user_root_path(user))
        end
      end

      context "when friendship doesn't involve current user" do
        let(:friendship) { create(:friendship, friender: non_friend, 
                                   friended: friend, accepted: false) }

        it "shows flash with denied message" do
          xhr :patch, :update, id: friendship.id
          expect(flash[:alert]).to include("Access denied.")
        end
        it "redirects" do
          xhr :patch, :update, id: friendship.id
          expect(response.status).to eq(302)
        end
        it "redirects to current user's root path" do
          xhr :patch, :update, id: friendship.id
          expect(response).to redirect_to(user_root_path(user))
        end
      end

    end

  end

  describe "DELETE destroy" do
    context "without Ajax" do 
      before { make_friends(user, friend) }
      let(:friendship) { Friendship.first }

      it "decrements the Friendship count" do 
        expect { delete :destroy, id: friendship.id, user_id: friend.id }.
                 to change{Friendship.count}.by(-1)
      end
    end

    context "with Ajax" do 
      context "when current user is friended" do
        before { make_friends(user, friend) }
        let(:friendship) { Friendship.first }

        it "decrements the Friendship count" do 
          expect { xhr :delete, :destroy, id: friendship.id, 
                   user_id: friend.id}.to change{ Friendship.count }.by(-1)
         end
         it "responds with success" do 
          xhr :delete, :destroy, id: friendship.id, user_id: friend.id
          expect(response).to be_success
        end
      end

      context "when current user is friender" do
        before { make_friends(friend, user) }
        let(:friendship) { Friendship.first }

        it "decrements the Friendship count" do 
          expect { xhr :delete, :destroy, id: friendship.id, 
                   user_id: friend.id}.to change{ Friendship.count }.by(-1)
         end
         it "responds with success" do 
          xhr :delete, :destroy, id: friendship.id, user_id: friend.id
          expect(response).to be_success
        end
      end

      context "when friendship doesn't involve current user" do
        before { make_friends(friend, non_friend) }
        let(:friendship) { Friendship.first }

        it "shows flash with denied message" do
          xhr :delete, :destroy, id: friendship.id, user_id: friend.id
          expect(flash[:alert]).to include("Access denied.")
        end
        it "redirects" do
          xhr :delete, :destroy, id: friendship.id, user_id: friend.id
          expect(response.status).to eq(302)
        end
        it "redirects to current user's root path" do
          xhr :delete, :destroy, id: friendship.id, user_id: friend.id
          expect(response).to redirect_to(user_root_path(user))
        end
      end
    end

  end
end
