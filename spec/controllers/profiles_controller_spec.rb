require 'spec_helper'

describe ProfilesController do
  let(:user) { create(:user) }

  before(:each) do
    sign_in user
    request.env["HTTP_REFERER"] = user_root_path(user) unless request.nil? or request.env.nil?
  end

  describe "GET show" do 
    context "for current user" do
      let(:profile) { create(:profile, user: user) }
      before { get :show, id: profile.id }

      it "shows profile" do
        expect(response).to render_template("show")
      end
      it "responds with success" do
        expect(response).to be_success
      end
    end

    context "for friend of current user" do
      let(:friend) { create(:user) }
      let(:profile) { create(:profile, user: friend) }
      before(:each) do 
        make_friends(user, friend)
        get :show, id: profile.id
      end

      it "shows profile" do
        expect(response).to render_template("show")
      end
      it "responds with success" do
        expect(response).to be_success
      end
    end

    context "for non-friend of current user with public profile" do
      let(:public_non_friend) { create(:user) }
      let(:profile) { create(:profile, user: public_non_friend) }
      before { get :show, id: profile.id }

      it "shows profile" do
        expect(response).to render_template("show")
      end
      it "responds with success" do
        expect(response).to be_success
      end
    end

    context "for non-friend of current user with private profile" do
      let(:private_non_friend) { create(:user) }
      let(:profile) { create(:profile, user: private_non_friend, 
                                       access_to: "Friends") }
      before { get :show, id: profile.id }

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


  describe "GET edit" do 
    context "for current user" do
      let(:profile) { create(:profile, user: user) }
      before { get :edit, id: profile.id }

      it "shows edit profile" do
        expect(response).to render_template("edit")
      end
      it "responds with success" do
        expect(response).to be_success
      end
    end

    context "for friend of current user" do
      let(:friend) { create(:user) }
      let(:profile) { create(:profile, user: friend) }
      before(:each) do 
        make_friends(user, friend)
        get :edit, id: profile.id
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

    context "for non-friend of current user with public profile" do
      let(:public_non_friend) { create(:user) }
      let(:profile) { create(:profile, user: public_non_friend) }
      before { get :edit, id: profile.id }

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

    context "for non-friend of current user with private profile" do
      let(:private_non_friend) { create(:user) }
      let(:profile) { create(:profile, user: private_non_friend, 
                                       access_to: "Friends") }
      before { get :edit, id: profile.id }

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


  describe "PATCH update" do 
    context "for current user" do
      let(:profile) { create(:profile, user: user) }
      before(:each) do 
        patch :update, id: profile.id, profile: { access_to: "Friends",
                                                email_notification: false }
        profile.reload
      end

      it "updates the profile" do
        expect(profile.email_notification).to be_false
      end
      it "shows updated profile" do
        expect(response).to redirect_to(profile)
      end
    end

    context "for friend of current user" do
      let(:friend) { create(:user) }
      let(:profile) { create(:profile, user: friend) }
      before(:each) do 
        make_friends(user, friend)
        patch :update, id: profile.id, profile: { access_to: "Friends",
                                                email_notification: false }
        profile.reload
      end

      it "shows flash with denied message" do
        expect(flash[:alert]).to include("Access denied.")
      end
      it "redirects to user's root path" do
        expect(response).to redirect_to(user_root_path(user))
      end
    end

    context "for non-friend of current user with public profile" do
      let(:public_non_friend) { create(:user) }
      let(:profile) { create(:profile, user: public_non_friend) }
      before(:each) do 
        patch :update, id: profile.id, profile: { access_to: "Friends",
                                                email_notification: false }
        profile.reload
      end

      it "shows flash with denied message" do
        expect(flash[:alert]).to include("Access denied.")
      end
      it "redirects to user's root path" do
        expect(response).to redirect_to(user_root_path(user))
      end
    end

    context "for non-friend of current user with private profile" do
      let(:private_non_friend) { create(:user) }
      let(:profile) { create(:profile, user: private_non_friend, 
                                       access_to: "Friends") }
      before(:each) do 
        patch :update, id: profile.id, profile: { access_to: "Friends",
                                                email_notification: false }
        profile.reload
      end

      it "shows flash with denied message" do
        expect(flash[:alert]).to include("Access denied.")
      end
      it "redirects to user's root path" do
        expect(response).to redirect_to(user_root_path(user))
      end
    end

  end
end
