require 'spec_helper'

describe Like do
  context 'for Post' do
    let(:post_like) { create(:post_like) }
    subject { post_like }

    it { should be_valid }
    it { should respond_to(:likeable) }
    it { should respond_to(:user) }
    its(:likeable) { should be_kind_of(Post) }

    describe 'associations' do 
      it { should belong_to(:likeable) }
      it { should belong_to(:user) }
    end

    describe 'validations' do 
      it { should validate_presence_of(:likeable_id) }
      it { should validate_presence_of(:likeable_type) }
      it { should validate_presence_of(:user_id) }
    end
  end

  context 'for Comment' do
    let(:comment_like) { create(:comment_like) }
    subject { comment_like }

    it { should be_valid }
    it { should respond_to(:likeable) }
    it { should respond_to(:user) }
    its(:likeable) { should be_kind_of(Comment) }

    describe 'associations' do 
      it { should belong_to(:likeable) }
      it { should belong_to(:user) }
    end

    describe 'validations' do 
      it { should validate_presence_of(:likeable_id) }
      it { should validate_presence_of(:likeable_type) }
      it { should validate_presence_of(:user_id) }
    end
  end

  describe "attempted multiple likes" do
    let(:post)  { create(:post) }
    let(:liker) { post.receiver }

    it "allows first like" do
      expect{ post.likes.create(user_id: liker.id) }.
              to change{ Like.count }.by(1)
    end
    it "prevents more than one like" do
      expect{ post.likes.create(user_id: liker.id) }.
              to change{ Like.count }.by(1)
      expect{ post.likes.create(user_id: liker.id) }.
              not_to change{ Like.count }
    end
  end

end
