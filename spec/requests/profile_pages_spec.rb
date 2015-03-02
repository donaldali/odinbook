require 'spec_helper'

describe "Profile Pages" do
  let(:user)    { create(:user) }
  let(:profile) { user.profile }
  subject { page }
  before { log_in(user) }

  describe "Edit Page" do 
    context "for current user" do
      before { visit edit_profile_path(profile) }

      it { should have_select("profile_birthday_2i") }
      it { should have_select("profile_birthday_3i") }
      it { should have_select("Country") }
      it { should have_select("Education") }
      it { should have_select("Profession") }
      it { should have_selector("textarea") }
      it { should have_checked_field("All Users") }
      it { should have_checked_field("Yes") }
      it { should have_submit("Update Profile") }
      it { should have_link("Cancel") }
      it { should have_button("Delete Odinbook Account") }
    end

    context "for friends" do 
      let(:friend_profile) { create(:profile) }
      let(:friend)         { friend_profile.user }
      before(:each) do 
        make_friends2(user, friend)
        visit edit_profile_path(friend_profile)
      end

      it "redirects to user's root page" do 
        expect(current_path).to eq(user_root_path(user))
      end
      it "displays denied flash message" do
        expect(page).to have_css(".flash.alert")
        expect(page).to have_text("Access denied.")
      end
    end

    context "for non-friend with public profile" do 
      let(:public_profile) { create(:profile) }
      let(:public_user)    { public_profile.user }
      before(:each) do 
        visit edit_profile_path(public_profile)
      end

      it "redirects to user's root page" do 
        expect(current_path).to eq(user_root_path(user))
      end
      it "displays denied flash message" do
        expect(page).to have_css(".flash.alert")
        expect(page).to have_text("Access denied.")
      end
    end

    context "for non-friend with private profile" do 
      let(:private_profile) { create(:profile, access_to: ACCESS[:friends]) }
      let(:private_user)    { private_profile.user }
      before(:each) do 
        visit edit_profile_path(private_profile)
      end

      it "redirects to user's root page" do 
        expect(current_path).to eq(user_root_path(user))
      end
      it "displays denied flash message" do
        expect(page).to have_css(".flash.alert")
        expect(page).to have_text("Access denied.")
      end
    end
  end


  describe "Show Page" do 
    context "for current user" do
      before(:each) do
        visit edit_profile_path(profile)
        select("Dec",                  from: "profile_birthday_2i")
        select("7",                    from: "profile_birthday_3i")
        select("Australia",            from: "Country")
        select("Some College",         from: "Education")
        select("Practicing Developer", from: "Profession")
        fill_in("profile_about_you",   with: "Lorem ipsum")
        choose("Friends")
        choose("No")
        click_on("Update Profile")
      end

      context "for current user" do 
        it "displays gender" do
          expect(page).to have_text("Gender")
          expect(page).to have_text("Male")
        end
        it "displays birthday" do
          expect(page).to have_text("Birthday")
          expect(page).to have_text("December 7")
        end
        it "displays country" do
          expect(page).to have_text("Country")
          expect(page).to have_text("Australia")
        end
        it "displays education" do
          expect(page).to have_text("Education")
          expect(page).to have_text("Some College")
        end
        it "displays profession" do
          expect(page).to have_text("Profession")
          expect(page).to have_text("Practicing Developer")
        end
        it "displays about" do
          expect(page).to have_text("About")
          expect(page).to have_text("Lorem ipsum")
        end
        it "displays access" do
          expect(page).to have_text("access to your Profile and Posts")
          expect(page).to have_text("Friends")
        end
        it "displays email notifications" do
          expect(page).to have_text("Will you receive email of notifications")
          expect(page).to have_text("No")
        end
        it "displays link to edit profile" do
          expect(page).to have_link("Edit Your Profile")
        end
      end
    end

    context "for friends" do 
      let(:friend_profile) { create(:profile) }
      let(:friend)         { friend_profile.user }
      before(:each) do 
        make_friends2(user, friend)
        visit profile_path(friend_profile)
      end

      it "displays gender" do
        expect(page).to have_text("Gender")
      end
      it "displays birthday" do
        expect(page).to have_text("Birthday")
      end
      it "displays country" do
        expect(page).to have_text("Country")
      end
      it "displays education" do
        expect(page).to have_text("Education")
      end
      it "displays profession" do
        expect(page).to have_text("Profession")
      end
      it "displays about" do
        expect(page).to have_text("About")
      end
      it "does not display access" do
        expect(page).not_to have_text("access to your Profile and Posts")
      end
      it "does not display email notifications" do
        expect(page).not_to have_text("Will you receive email of notifications")
      end
      it "does not display link to edit profile" do
        expect(page).not_to have_link("Edit Your Profile")
      end
    end

    context "for non-friend with public profile" do 
      let(:public_profile) { create(:profile) }
      let(:public_user)    { public_profile.user }
      before(:each) do 
        visit profile_path(public_profile)
      end

      it "displays gender" do
        expect(page).to have_text("Gender")
      end
      it "displays birthday" do
        expect(page).to have_text("Birthday")
      end
      it "displays country" do
        expect(page).to have_text("Country")
      end
      it "displays education" do
        expect(page).to have_text("Education")
      end
      it "displays profession" do
        expect(page).to have_text("Profession")
      end
      it "displays about" do
        expect(page).to have_text("About")
      end
      it "does not display access" do
        expect(page).not_to have_text("access to your Profile and Posts")
      end
      it "does not display email notifications" do
        expect(page).not_to have_text("Will you receive email of notifications")
      end
      it "does not display link to edit profile" do
        expect(page).not_to have_link("Edit Your Profile")
      end
    end

    context "for non-friend with private profile" do 
      let(:private_profile) { create(:profile, access_to: ACCESS[:friends]) }
      let(:private_user)    { private_profile.user }
      before(:each) do 
        visit profile_path(private_profile)
      end

      it "redirects to user's root page" do 
        expect(current_path).to eq(user_root_path(user))
      end
      it "displays denied flash message" do
        expect(page).to have_css(".flash.alert")
        expect(page).to have_text("Access denied.")
      end
    end

  end
end
