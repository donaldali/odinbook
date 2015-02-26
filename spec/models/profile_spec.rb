require 'spec_helper'

describe Profile do 
  let(:profile) { create(:profile) }
  subject { profile }

  it { should be_valid }
  it { should respond_to(:birthday) }
  it { should respond_to(:country) }
  it { should respond_to(:education) }
  it { should respond_to(:profession) }
  it { should respond_to(:about_you) }
  it { should respond_to(:access_to) }
  it { should respond_to(:email_notification) }

  describe "association" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:access_to) }
  end
end
