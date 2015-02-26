require 'spec_helper'

describe "Profile Pages" do
  let(:user)    { create(:user) }
  let(:profile) { user.profile }
  subject { page }
  before { log_in(user) }

  describe "Edit Page" do 
    before { visit edit_profile_path(user) }

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

  describe "Show Page" do 
    before(:each) do
      visit edit_profile_path(user)
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
      it "displays birthday" do
        expect(page).to have_text("Birthday")
        expect(page).to have_text("December 7")
      end
      it "displays birthday" do
        expect(page).to have_text("Country")
        expect(page).to have_text("Australia")
      end
      it "displays birthday" do
        expect(page).to have_text("Education")
        expect(page).to have_text("Some College")
      end
      it "displays birthday" do
        expect(page).to have_text("Profession")
        expect(page).to have_text("Practicing Developer")
      end
      it "displays birthday" do
        expect(page).to have_text("About")
        expect(page).to have_text("Lorem ipsum")
      end
      it "displays birthday" do
        expect(page).to have_text("access to your Profile and Posts")
        expect(page).to have_text("Friends")
      end
      it "displays birthday" do
        expect(page).to have_text("Will you receive email of notifications")
        expect(page).to have_text("No")
      end

    end
  end
end
