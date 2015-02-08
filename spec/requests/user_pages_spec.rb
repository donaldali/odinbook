require "spec_helper"

describe "User pages" do 
  subject { page }
  let(:user) { create(:user) }

  before(:each) do
    log_in(user)
    # visit newsfeed_path(user)
  end

  describe "newsfeed" do

    it { should have_text("Newsfeed") }
    it { should have_text(user.first_name) }

    it 'should match user' do 
      expect(user.first_name).to eq("John")
    end

  end
end
