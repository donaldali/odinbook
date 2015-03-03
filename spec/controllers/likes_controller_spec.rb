require 'spec_helper'

describe LikesController do
  let(:user)              { create(:user) }
  let(:likeable_post)     { create(:post) }
  let(:likeable_comment)  { create(:comment) }

  before(:each) do
    sign_in user
    unless request.nil? or request.env.nil?
      request.env["HTTP_REFERER"] = user_root_path(user)
    end 
  end

  describe "POST create of post like" do
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

  describe "POST create of comment like" do
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

  describe "DELETE destroy of post like" do
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
      context "on current user like" do
        it "destroys a post like" do 
          expect { xhr :delete, :destroy, id: like.id }.
          to change{Like.count}.by(-1)
        end
        it "responds with success" do
          xhr :delete, :destroy, id: like.id
          expect(response).to be_success
        end
      end

      context "on current user's friend's like" do
        let(:friend) { create(:user) }
        before(:each) do 
          make_friends(user, friend)
          create(:post_like, user: friend, likeable: likeable_post)
        end
        let(:like) { Like.last }

        it "shows flash with denied message" do
          xhr :delete, :destroy, id: like.id
          expect(flash[:alert]).to include("Access denied.")
        end
        it "redirects" do
          xhr :delete, :destroy, id: like.id
          expect(response.status).to eq(302)
        end
        it "redirects to current user's root path" do
          xhr :delete, :destroy, id: like.id
          expect(response).to redirect_to(user_root_path(user))
        end
      end

      context "on current user's non-friend's like" do
        let(:non_friend) { create(:user) }
        before(:each) do 
          create(:post_like, user: non_friend, likeable: likeable_post)
        end
        let(:like) { Like.last }

        it "shows flash with denied message" do
          xhr :delete, :destroy, id: like.id
          expect(flash[:alert]).to include("Access denied.")
        end
        it "redirects" do
          xhr :delete, :destroy, id: like.id
          expect(response.status).to eq(302)
        end
        it "redirects to current user's root path" do
          xhr :delete, :destroy, id: like.id
          expect(response).to redirect_to(user_root_path(user))
        end
      end

    end
  end

  describe "DELETE destroy of comment like" do
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
      context "on current user like" do
        it "destroys a comment like" do 
          expect { xhr :delete, :destroy, id: like.id }.
          to change{Like.count}.by(-1)
        end
        it "responds with success" do
          xhr :delete, :destroy, id: like.id
          expect(response).to be_success
        end
      end

      context "on current user's friend's like" do
        let(:friend) { create(:user) }
        before(:each) do 
          make_friends(user, friend)
          create(:comment_like, user: friend, likeable: likeable_comment)
        end
        let(:like) { Like.last }

        it "shows flash with denied message" do
          xhr :delete, :destroy, id: like.id
          expect(flash[:alert]).to include("Access denied.")
        end
        it "redirects" do
          xhr :delete, :destroy, id: like.id
          expect(response.status).to eq(302)
        end
        it "redirects to current user's root path" do
          xhr :delete, :destroy, id: like.id
          expect(response).to redirect_to(user_root_path(user))
        end
      end

      context "on current user's non-friend's like" do
        let(:non_friend) { create(:user) }
        before(:each) do 
          create(:comment_like, user: non_friend, likeable: likeable_comment)
        end
        let(:like) { Like.last }

        it "shows flash with denied message" do
          xhr :delete, :destroy, id: like.id
          expect(flash[:alert]).to include("Access denied.")
        end
        it "redirects" do
          xhr :delete, :destroy, id: like.id
          expect(response.status).to eq(302)
        end
        it "redirects to current user's root path" do
          xhr :delete, :destroy, id: like.id
          expect(response).to redirect_to(user_root_path(user))
        end
      end

    end
  end

end
