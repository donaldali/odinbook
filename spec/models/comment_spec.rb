require 'spec_helper'

describe 'Comment' do 
  let(:comment) { create(:comment) }
  subject { comment }

  it { should be_valid }
  it { should respond_to(:content) }
  it { should respond_to(:post) }
  it { should respond_to(:commenter) }

  describe "associations" do 
    it { should belong_to(:post) }
    it { should belong_to(:commenter) }
  end

  describe "validations" do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:post_id) }
    it { should validate_presence_of(:commenter_id) }
  end
end
