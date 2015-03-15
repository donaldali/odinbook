require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "Sign Up" do 
    before { visit signup_path }

    it { should have_button("Sign Up") }

    context "with sign up form" do
      before { fill_sign_up }

      it "signs up and creates user" do
        expect{ click_button("Sign Up") }.to change{ User.count }.by(1)
        expect(page).to have_text("Welcome to Odinbook!")
      end
      it "requires first name" do
        fill_in "First name", with: ""
        expect{ click_button("Sign Up") }.not_to change{ User.count }
        expect(page).to have_text("First name can't be blank")
      end
      it "requires last name" do
        fill_in "Last name", with: ""
        expect{ click_button("Sign Up") }.not_to change{ User.count }
        expect(page).to have_text("Last name can't be blank")
      end
      it "requires email" do
        within("#signup-form") { fill_in "Email", with: "" }
        expect{ click_button("Sign Up") }.not_to change{ User.count }
        expect(page).to have_text("Email can't be blank")
      end
      it "requires password" do
        within("#signup-form")  { fill_in "Password", with: "" }
        expect{ click_button("Sign Up") }.not_to change{ User.count }
        expect(page).to have_text("Password can't be blank")
      end
      it "requires password confirmation" do
        fill_in "Password confirmation", with: ""
        expect{ click_button("Sign Up") }.not_to change{ User.count }
        expect(page).to have_text("Password confirmation doesn't match Password")
      end
    end

    context "with Facebook" do
      before { OmniAuth.config.mock_auth[:facebook] = nil }

      it "can sign up a user" do
        mock_auth_hash
        expect{ click_link "Login with Facebook" }.to change{ User.count }.by(1)
        expect(page).to have_text("Welcome to Odinbook!")
      end
      it "can handle authentication error" do
        OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
        expect{ click_link "Login with Facebook" }.not_to change{ User.count }
        expect(page).to have_text("Invalid credentials")
      end
    end
  end

  describe "Sign In" do 
    let(:user) { create(:user) }
    before { visit new_user_session_path }

    it { should have_button("Log In") }

    context "with signin form" do
      it "signs in user" do
        log_in(user)
        expect(current_path).to eq(user_root_path(user))
      end
      it "doesn't sign in user with wrong password" do
        within("#login-form") do
          fill_in "Email",    with: user.email
          fill_in "Password", with: "foobar"
        end
        click_button "Log In"
        expect(page).to have_text("Invalid email or password")
      end
    end

    context "with Facebook" do
      let!(:user) { create(:user, email: "john@doe.com") }
      before { OmniAuth.config.mock_auth[:facebook] = nil }

      it "can log in a user" do
        mock_auth_hash
        click_link "Login with Facebook"
        expect(current_path).to eq(user_root_path(user))
      end
      it "can handle authentication error" do
        OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
        click_link "Login with Facebook"
        expect(page).to have_text("Invalid credentials")
      end
    end
  end
end
