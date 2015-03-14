require 'spec_helper'

describe "Static Pages" do
  subject { page }
  before  { visit root_path }

  it { should have_link("About") }
  it { should have_link("Contact / Help") }
  it { should have_link("Privacy") }
  it { should have_link("Terms of Service") }

  describe "About page" do 
    before { visit about_path }

    it { should have_title("About Odinbook") }
    it { should have_selector("h2", text: "About Us") }
  end

  describe "Contact/Help page" do 
    before { visit contact_help_path }

    it { should have_title("Contact | Help") }
    it { should have_selector("h2", text: "Contact or Help") }
  end

  describe "Privacy page" do 
    before { visit privacy_path }
    
    it { should have_title("Privacy Policy") }
    it { should have_selector("h2", text: "Privacy Policy") }
  end

  describe "Terms of Service page" do 
    before { visit terms_path }
    
    it { should have_title("Terms of Service") }
    it { should have_selector("h2", text: "Terms of Service") }
  end
end
