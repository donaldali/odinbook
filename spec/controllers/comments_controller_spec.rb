require 'spec_helper'

describe CommentsController do 
  let(:commenter) { create(:commenter) }
  let(:a_post)  { create(:post, receiver: commenter) }

  before(:each) do
    sign_in commenter 
    request.env["HTTP_REFERER"] = "/" unless request.nil? or request.env.nil?
  end

  describe "create comment" do 
    context "without Ajax" do
      it "creates a comment" do
        expect { post :create, comment: { content: "Lorem" }, 
                 post_id: a_post.id }.to change{ Comment.count }.by(1)
      end
    end

    context "with Ajax" do 
      it "creates a comment" do 
        expect { xhr :post, :create, comment: { content: "Lorem" }, 
                 post_id: a_post.id }.to change{ Comment.count }.by(1)
      end
      it "responds with success" do
        xhr :post, :create, comment: {content: "Lorem"}, post_id: a_post.id 
        expect(response).to be_success
      end
    end
  end

  describe "destroy comment" do
    before(:each) do 
      create(:comment, commenter: commenter, post: a_post)
    end
    let(:comment) { Comment.last }

    context "without Ajax" do
      it "destroys a comment" do
        expect { delete :destroy, id: comment.id }.to change{ Comment.count }.by(-1)
      end
    end

    context "with Ajax" do
      it "destroys a comment" do 
        expect { xhr :delete, :destroy, id: comment.id }.to change{ Comment.count }.by(-1)
      end

      it "responds with success" do 
        xhr :delete, :destroy, id: comment.id
        expect(response).to be_success
      end
    end
  end
end