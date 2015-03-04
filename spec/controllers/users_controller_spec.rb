require 'spec_helper'

describe UsersController do 
  let(:user) { create(:user) }

  before(:each) do
    sign_in user
    unless request.nil? or request.env.nil?
      request.env["HTTP_REFERER"] = user_root_path(user)
    end 
  end

  describe "GET newsfeed" do
    context "for current user" do
      before { get :newsfeed, id: user.id }

      it "shows newsfeed" do
        expect(response).to render_template("newsfeed")
      end
      it "responds with success" do
        expect(response).to be_success
      end
    end 

    context "for friend of current user" do
      let(:friend) { create(:user) }
      before(:each) do 
        make_friends(user, friend)
        get :newsfeed, id: friend.id
      end

      it "shows flash with denied message" do
        expect(flash[:alert]).to include("Access denied.")
      end
      it "redirects" do
        expect(response.status).to eq(302)
      end
      it "redirects to user's root path" do
        expect(response).to redirect_to(user_root_path(user))
      end
    end 

    context "for non-friend of current user" do
      let(:non_friend) { create(:user) }
      before { get :newsfeed, id: non_friend.id }

      it "shows flash with denied message" do
        expect(flash[:alert]).to include("Access denied.")
      end
      it "redirects" do
        expect(response.status).to eq(302)
      end
      it "redirects to user's root path" do
        expect(response).to redirect_to(user_root_path(user))
      end
    end 
  end

  describe "GET friend_requests" do
    context "for current user" do
      before { get :friend_requests, id: user.id }

      it "shows friend requests" do
        expect(response).to render_template("index")
      end
      it "responds with success" do
        expect(response).to be_success
      end
    end 

    context "for friend of current user" do
      let(:friend) { create(:user) }
      before(:each) do 
        make_friends(user, friend)
        get :friend_requests, id: friend.id
      end

      it "shows flash with denied message" do
        expect(flash[:alert]).to include("Access denied.")
      end
      it "redirects" do
        expect(response.status).to eq(302)
      end
      it "redirects to user's root path" do
        expect(response).to redirect_to(user_root_path(user))
      end
    end 

    context "for non-friend of current user" do
      let(:non_friend) { create(:user) }
      before { get :friend_requests, id: non_friend.id }

      it "shows flash with denied message" do
        expect(flash[:alert]).to include("Access denied.")
      end
      it "redirects" do
        expect(response.status).to eq(302)
      end
      it "redirects to user's root path" do
        expect(response).to redirect_to(user_root_path(user))
      end
    end 
  end
  
  describe "GET find_friends" do
    context "for current user" do
      before { get :find_friends, id: user.id }

      it "shows non-friends" do
        expect(response).to render_template("index")
      end
      it "responds with success" do
        expect(response).to be_success
      end
    end 

    context "for friend of current user" do
      let(:friend) { create(:user) }
      before(:each) do 
        make_friends(user, friend)
        get :find_friends, id: friend.id
      end

      it "shows flash with denied message" do
        expect(flash[:alert]).to include("Access denied.")
      end
      it "redirects" do
        expect(response.status).to eq(302)
      end
      it "redirects to user's root path" do
        expect(response).to redirect_to(user_root_path(user))
      end
    end 

    context "for non-friend of current user" do
      let(:non_friend) { create(:user) }
      before { get :find_friends, id: non_friend.id }

      it "shows flash with denied message" do
        expect(flash[:alert]).to include("Access denied.")
      end
      it "redirects" do
        expect(response.status).to eq(302)
      end
      it "redirects to user's root path" do
        expect(response).to redirect_to(user_root_path(user))
      end
    end 
  end
  
  describe "GET friends" do
    context "with 'from' parameter not set to 'profile'" do 
      context "for current user" do
        before { get :friends, id: user.id }

        it "shows current user's friends" do
          expect(response).to render_template("index")
        end
        it "responds with success" do
          expect(response).to be_success
        end
      end

      context "for friend of current user" do
        let(:friend) { create(:user) }
        before(:each) do 
          make_friends(user, friend)
          get :friends, id: friend.id
        end

        it "shows flash with denied message" do
          expect(flash[:alert]).to include("Access denied.")
        end
        it "redirects" do
          expect(response.status).to eq(302)
        end
        it "redirects to user's root path" do
          expect(response).to redirect_to(user_root_path(user))
        end
      end 

      context "for non-friend of current user" do
        let(:non_friend) { create(:user) }
        before { get :friends, id: non_friend.id }

        it "shows flash with denied message" do
          expect(flash[:alert]).to include("Access denied.")
        end
        it "redirects" do
          expect(response.status).to eq(302)
        end
        it "redirects to user's root path" do
          expect(response).to redirect_to(user_root_path(user))
        end
      end 
    end


    context "with 'from' parameter set to 'profile'" do 
      context "for current user" do
        before { get :friends, id: user.id, from: 'profile' }

        it "shows current user's friends" do
          expect(response).to render_template("profiles/friends")
        end
        it "responds with success" do
          expect(response).to be_success
        end
      end

      context "for friend of current user" do
        let(:friend) { create(:user) }
        before(:each) do 
          make_friends(user, friend)
          get :friends, id: friend.id, from: 'profile'
        end

        it "shows friend's friends" do
          expect(response).to render_template("profiles/friends")
        end
        it "responds with success" do
          expect(response).to be_success
        end
      end 

      context "for non-friend of current user with public profile" do
        let(:public_non_friend) { create(:user) }
        before { get :friends, id: public_non_friend.id, from: 'profile' }

        it "shows friends of non-friend with public profile" do
          expect(response).to render_template("profiles/friends")
        end
        it "responds with success" do
          expect(response).to be_success
        end
      end 

      context "for non-friend of current user with private profile" do
        let(:private_non_friend) { create(:user) }
        let(:profile) { create(:profile, user: private_non_friend, 
                                         access_to: ACCESS[:friends]) }
        before { 
          private_non_friend.profile.update_attributes(access_to: ACCESS[:friends])
          get :friends, id: private_non_friend.id, from: 'profile' 
        }

        it "shows flash with denied message" do
          expect(flash[:alert]).to include("Access denied.")
        end
        it "redirects" do
          expect(response.status).to eq(302)
        end
        it "redirects to user's root path" do
          expect(response).to redirect_to(user_root_path(user))
        end
      end 
    end
  end
  
end
