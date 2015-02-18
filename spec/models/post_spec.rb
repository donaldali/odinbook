require 'spec_helper'

describe Post do
  let(:post) { FactoryGirl.create(:post) }
  subject { post }

  it { should be_valid }
  it { should respond_to(:content) }
  it { should respond_to(:creator) }
  it { should respond_to(:receiver) }

  describe "associations" do 
    it { should belong_to(:creator) }
    it { should belong_to(:receiver) }
  end

  describe "validations" do 
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:creator_id) }
    it { should validate_presence_of(:receiver_id) }
  end
end
