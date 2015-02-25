require 'spec_helper'

describe PostsController do
  let(:creator)  { create(:creator) }
  let(:receiver) { create(:receiver) }

  before(:each) do
    sign_in creator
    request.env["HTTP_REFERER"] = "/" unless request.nil? or request.env.nil?
  end

  describe "create post" do
    context "without Ajax" do
      it "creates a post" do
        expect { post :create, receiver_id: receiver.id, 
                 post: { content: "Lorem" } }.to change{ Post.count }.by(1)
      end
    end

    context "with Ajax" do 
      it "creates a post" do 
        expect { xhr :post, :create, receiver_id: receiver.id, 
                 post: { content: "Lorem"} }.to change{ Post.count }.by(1)
      end
      it "responds with success" do
        xhr :post, :create, receiver_id: receiver.id, post: {content: "Lorem"}
        expect(response).to be_success
      end
    end
  end

  describe "destroy post" do
    before(:each) do 
      create(:post, creator: creator, receiver: receiver)
    end
    let(:post) { Post.last }

    context "without Ajax" do 
      it "destroys a post" do 
        expect { delete :destroy, id: post.id }.to change{Post.count}.by(-1)
      end
    end

    context "with Ajax" do 
      it "destroys a post" do 
        expect { xhr :delete, :destroy, id: post.id }.
                 to change{Post.count}.by(-1)
      end
      it "responds with success" do
        xhr :delete, :destroy, id: post.id
        expect(response).to be_success
      end
    end
  end
end
