require 'spec_helper'

describe PostsController do
  let(:creator)  { create(:creator) }

  before(:each) do
    sign_in creator
    unless request.nil? or request.env.nil?
      request.env["HTTP_REFERER"] = user_root_path(creator)
    end 
  end

  describe "POST create" do
    context "without Ajax" do
      it "creates a post" do
        expect { post :create, receiver_id: creator.id, 
                 post: { content: "Lorem" } }.to change{ Post.count }.by(1)
      end
    end

    context "with Ajax" do 
      context "posting to current user" do
        it "creates a post" do 
          expect { xhr :post, :create, receiver_id: creator.id, 
           post: { content: "Lorem"} }.to change{ Post.count }.by(1)
         end
         it "responds with success" do
          xhr :post, :create, receiver_id: creator.id, 
                              post: {content: "Lorem"}
          expect(response).to be_success
        end
      end

      context "posting to friend of current user" do
        let(:friend) { create(:user) }
        before { make_friends(creator, friend) }

        it "creates a post" do 
          expect { xhr :post, :create, receiver_id: friend.id, 
           post: { content: "Lorem"} }.to change{ Post.count }.by(1)
         end
         it "responds with success" do
          xhr :post, :create, receiver_id: friend.id, post: {content: "Lorem"}
          expect(response).to be_success
        end
      end

      context "posting to non-friend of current user with public profile" do
        let(:public_non_friend) { create(:user) }
        before(:each) do
          xhr :post, :create, receiver_id: public_non_friend.id, 
                              post: {content: "Lorem"}
        end

        it "shows flash with denied message" do
          expect(flash[:alert]).to include("Access denied.")
        end
        it "redirects" do
          expect(response.status).to eq(302)
        end
        it "redirects to current user's root path" do
          expect(response).to redirect_to(user_root_path(creator))
        end
      end

      context "posting to non-friend of current user with private profile" do
        let(:private_non_friend) { create(:user) }
        let(:profile) { create(:profile, user: private_non_friend, 
                                         access_to: ACCESS[:friends] ) }
        before(:each) do
          xhr :post, :create, receiver_id: private_non_friend.id, 
                              post: {content: "Lorem"}
        end

        it "shows flash with denied message" do
          expect(flash[:alert]).to include("Access denied.")
        end
        it "redirects" do
          expect(response.status).to eq(302)
        end
        it "redirects to current user's root path" do
          expect(response).to redirect_to(user_root_path(creator))
        end
      end

    end
  end


  describe "DELETE destroy" do
    context "without Ajax" do 
      let(:receiver) { create(:receiver) }
      before { create(:post, creator: creator, receiver: receiver) }
      let(:post) { Post.last }

      it "destroys a post" do 
        expect { delete :destroy, id: post.id }.to change{Post.count}.by(-1)
      end
    end

    context "with Ajax" do 
      let(:other_user) { create(:user) }

      context "deleting post of current user" do
        context "as creator" do
          before { create(:post, creator: creator, receiver: other_user) }
          let(:post) { Post.last }

          it "destroys a post" do 
            expect { xhr :delete, :destroy, id: post.id }.
              to change{Post.count}.by(-1)
          end
          it "responds with success" do
            xhr :delete, :destroy, id: post.id
            expect(response).to be_success
          end
        end
        context "as receiver" do
          before { create(:post, creator: other_user, receiver: creator) }
          let(:post) { Post.last }

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

      context "deleting post of current user's friend" do
        let(:friend) { create(:user) }
        before { make_friends(creator, friend) }

        context "as creator" do
          before { create(:post, creator: friend, receiver: other_user) }
          let(:post) { Post.last }

          it "shows flash with denied message" do
            xhr :delete, :destroy, id: post.id
            expect(flash[:alert]).to include("Access denied.")
          end
          it "redirects" do
            xhr :delete, :destroy, id: post.id
            expect(response.status).to eq(302)
          end
          it "redirects to current user's root path" do
            xhr :delete, :destroy, id: post.id
            expect(response).to redirect_to(user_root_path(creator))
          end
        end
        context "as receiver" do
          before { create(:post, creator: other_user, receiver: friend) }
          let(:post) { Post.last }

          it "shows flash with denied message" do
            xhr :delete, :destroy, id: post.id
            expect(flash[:alert]).to include("Access denied.")
          end
          it "redirects" do
            xhr :delete, :destroy, id: post.id
            expect(response.status).to eq(302)
          end
          it "redirects to current user's root path" do
            xhr :delete, :destroy, id: post.id
            expect(response).to redirect_to(user_root_path(creator))
          end
        end
      end

    end
  end
end
