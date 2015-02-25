require 'spec_helper'

describe LikesController do
  let(:user)              { create(:user) }
  let(:likeable_post)     { create(:post) }
  let(:likeable_comment)  { create(:comment) }

  before(:each) do
    sign_in user
    request.env["HTTP_REFERER"] = "/" unless request.nil? or request.env.nil?
  end

  describe "create post like" do
    context "without Ajax" do
      it "creates a post like" do
        expect { post :create, likeable_id: likeable_post.id,
                 likeable_type: "Post" }.to change{ Like.count }.by(1)
      end
    end

    context "with Ajax" do 
      it "creates a post like" do 
        expect { xhr :post, :create, likeable_id: likeable_post.id,
                 likeable_type: "Post" }.to change{ Like.count }.by(1)
      end
      it "responds with success" do
        xhr :post, :create, likeable_id: likeable_post.id,
                    likeable_type: "Post"
        expect(response).to be_success
      end
    end
  end

  describe "create comment like" do
    context "without Ajax" do
      it "creates a comment like" do
        expect { post :create, likeable_id: likeable_comment.id,
                 likeable_type: "Comment" }.to change{ Like.count }.by(1)
      end
    end

    context "with Ajax" do 
      it "creates a comment like" do 
        expect { xhr :post, :create, likeable_id: likeable_comment.id,
                 likeable_type: "Comment" }.to change{ Like.count }.by(1)
      end
      it "responds with success" do
        xhr :post, :create, likeable_id: likeable_comment.id,
                    likeable_type: "Comment"
        expect(response).to be_success
      end
    end
  end

  describe "destroy post like" do
    before(:each) do 
      create(:post_like, user: user, likeable: likeable_post)
    end
    let(:like) { Like.last }

    context "without Ajax" do 
      it "destroys a post like" do 
        expect { delete :destroy, id: like.id }.to change{Like.count}.by(-1)
      end
    end

    context "with Ajax" do 
      it "destroys a post like" do 
        expect { xhr :delete, :destroy, id: like.id }.
                 to change{Like.count}.by(-1)
      end
      it "responds with success" do
        xhr :delete, :destroy, id: like.id
        expect(response).to be_success
      end
    end
  end

  describe "destroy comment like" do
    before(:each) do 
      create(:comment_like, user: user, likeable: likeable_comment)
    end
    let(:like) { Like.last }

    context "without Ajax" do 
      it "destroys a comment like" do 
        expect { delete :destroy, id: like.id }.to change{Like.count}.by(-1)
      end
    end

    context "with Ajax" do 
      it "destroys a comment like" do 
        expect { xhr :delete, :destroy, id: like.id }.
                 to change{Like.count}.by(-1)
      end
      it "responds with success" do
        xhr :delete, :destroy, id: like.id
        expect(response).to be_success
      end
    end
  end

end
