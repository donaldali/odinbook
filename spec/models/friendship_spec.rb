require 'spec_helper'

describe Friendship do
  let(:friender) { create(:user) }
  let(:friended) { create(:user) }
  let(:friendship) { friender.friendships.build(friended_id: friended.id) }
  subject { friendship }

  it { should be_valid }
  it { should respond_to(:friender) }
  it { should respond_to(:friended) }
  it { should respond_to(:accepted) }
  its(:friender) { should eq friender }
  its(:friended) { should eq friended }
  its(:accepted) { should be_nil }

  describe "associations" do 
    it { should belong_to(:friender) }
    it { should belong_to(:friended) }
  end

  describe "validations" do 
    it { should validate_presence_of(:friender_id) }
    it { should validate_presence_of(:friended_id) }
  end

end
