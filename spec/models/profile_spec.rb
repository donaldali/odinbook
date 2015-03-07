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
  it { should have_attached_file(:picture) }

  describe "association" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:access_to) }
    it { should validate_attachment_content_type(:picture).
                allowing('image/png', 'image/gif', 
                         'image/jpg', 'image/jpeg').
                rejecting('text/plain', 'text/xml') }
    it { should validate_attachment_size(:picture).
                less_than(500.kilobytes) }
  end
end
