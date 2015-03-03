require 'spec_helper'

describe CommentsController do 
  let(:commenter) { create(:commenter) }
  let(:a_post)    { create(:post, receiver: commenter) }

  before(:each) do
    sign_in commenter 
    unless request.nil? or request.env.nil?
      request.env["HTTP_REFERER"] = user_root_path(commenter)
    end 
  end

  describe "POST create" do 
    context "without Ajax" do
      it "creates a comment" do
        expect { post :create, comment: { content: "Lorem" }, 
                 post_id: a_post.id }.to change{ Comment.count }.by(1)
      end
    end

    context "with Ajax" do 
      context "on current user created posts" do
        let(:a_post) { create(:post, creator: commenter) }

        it "creates a comment" do 
          expect { xhr :post, :create, comment: { content: "Lorem" }, 
                   post_id: a_post.id }.to change{ Comment.count }.by(1)
        end
        it "responds with success" do
          xhr :post, :create, comment: {content: "Lorem"}, post_id: a_post.id
          expect(response).to be_success
        end
      end

      context "on current user received posts" do
        it "creates a comment" do 
          expect { xhr :post, :create, comment: { content: "Lorem" }, 
                   post_id: a_post.id }.to change{ Comment.count }.by(1)
        end
        it "responds with success" do
          xhr :post, :create, comment: {content: "Lorem"}, post_id: a_post.id
          expect(response).to be_success
        end
      end
 
      context "on current user's friend created posts" do
        let(:friend) { create(:user) }
        let(:a_post) { create(:post, creator: friend) }
        before { make_friends(commenter, friend) }

        it "creates a comment" do 
          expect { xhr :post, :create, comment: { content: "Lorem" }, 
                   post_id: a_post.id }.to change{ Comment.count }.by(1)
        end
        it "responds with success" do
          xhr :post, :create, comment: {content: "Lorem"}, post_id: a_post.id
          expect(response).to be_success
        end
      end

      context "on current user's friend received posts" do
        let(:friend) { create(:user) }
        let(:a_post) { create(:post, receiver: friend) }
        before { make_friends(commenter, friend) }

        it "creates a comment" do 
          expect { xhr :post, :create, comment: { content: "Lorem" }, 
                   post_id: a_post.id }.to change{ Comment.count }.by(1)
        end
        it "responds with success" do
          xhr :post, :create, comment: {content: "Lorem"}, post_id: a_post.id
          expect(response).to be_success
        end
      end

      context "on current user's non-friend created posts" do
        let(:non_friend) { create(:user) }
        let(:a_post) { create(:post, creator: non_friend) }

        it "shows flash with denied message" do
          xhr :post, :create, comment: {content: "Lorem"}, post_id: a_post.id
          expect(flash[:alert]).to include("Access denied.")
        end
        it "redirects" do
          xhr :post, :create, comment: {content: "Lorem"}, post_id: a_post.id
          expect(response.status).to eq(302)
        end
        it "redirects to current user's root path" do
          xhr :post, :create, comment: {content: "Lorem"}, post_id: a_post.id
          expect(response).to redirect_to(user_root_path(commenter))
        end
      end

      context "on current user's non-friend received posts" do
        let(:non_friend) { create(:user) }
        let(:a_post) { create(:post, receiver: non_friend) }

        it "shows flash with denied message" do
          xhr :post, :create, comment: {content: "Lorem"}, post_id: a_post.id
          expect(flash[:alert]).to include("Access denied.")
        end
        it "redirects" do
          xhr :post, :create, comment: {content: "Lorem"}, post_id: a_post.id
          expect(response.status).to eq(302)
        end
        it "redirects to current user's root path" do
          xhr :post, :create, comment: {content: "Lorem"}, post_id: a_post.id
          expect(response).to redirect_to(user_root_path(commenter))
        end
      end

    end
  end

  describe "DELETE destroy" do
    before(:each) do 
      create(:comment, commenter: commenter, post: a_post)
    end
    let(:comment) { Comment.last }

    context "without Ajax" do
      it "destroys a comment" do
        expect { delete :destroy, id: comment.id }.
          to change{ Comment.count }.by(-1)
      end
    end

    context "with Ajax" do
      context "on current user comment" do
        it "destroys a comment" do 
          expect { xhr :delete, :destroy, id: comment.id }.
            to change{ Comment.count }.by(-1)
        end

        it "responds with success" do 
          xhr :delete, :destroy, id: comment.id
          expect(response).to be_success
        end
      end

      context "on current user's friend's comment" do
        let(:friend) { create(:user) }
        let(:a_post) { create(:post, creator: friend, receiver: friend) }
        before(:each) do 
          make_friends(commenter, friend)
          create(:comment, commenter: friend, post: a_post)
        end
        let(:comment) { Comment.last }

        it "shows flash with denied message" do
          xhr :delete, :destroy, id: comment.id
          expect(flash[:alert]).to include("Access denied.")
        end
        it "redirects" do
          xhr :delete, :destroy, id: comment.id
          expect(response.status).to eq(302)
        end
        it "redirects to current user's root path" do
          xhr :delete, :destroy, id: comment.id
          expect(response).to redirect_to(user_root_path(commenter))
        end
      end

      context "on current user's non-friend's comment" do
        let(:non_friend) { create(:user) }
        let(:a_post) { create(:post, creator:  non_friend, 
                                     receiver: non_friend) }
        before { create(:comment, commenter: non_friend, post: a_post) }
        let(:comment) { Comment.last }

        it "shows flash with denied message" do
          xhr :delete, :destroy, id: comment.id
          expect(flash[:alert]).to include("Access denied.")
        end
        it "redirects" do
          xhr :delete, :destroy, id: comment.id
          expect(response.status).to eq(302)
        end
        it "redirects to current user's root path" do
          xhr :delete, :destroy, id: comment.id
          expect(response).to redirect_to(user_root_path(commenter))
        end
      end

    end
  end
end