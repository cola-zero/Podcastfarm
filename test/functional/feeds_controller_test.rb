require 'test_helper'

describe FeedsController do

  tests FeedsController

  def valid_attributes
    { :url => "file://#{URI.escape(File.join(File.dirname(File.expand_path(__FILE__, Dir.getwd)), "..", "fixtures", "feed.rss"))}" }
  end

  context "when user signed in" do
    before (:each) do
      @user = Factory(:user)
      @controller.sign_in(@user)
    end

    describe "GET index" do
      it "assigns all feeds as @feeds" do
        feed = Factory(:feed)
        feed.register_user(@user)
        get :index
        assigns(:feeds).must_equal([feed])
      end

      it "should not assign another user's feed in @feeds" do
        feed = Factory(:feed)
        different_user = Factory(:user)
        feed.register_user(different_user)
        get :index
        assigns(:feeds).must_equal([])
      end
    end

        describe "GET show" do
      it "assigns the requested feed as @feed" do
        feed = Factory(:feed)
        get :show, :id => feed.id
        assigns(:feed).must_equal(feed)
      end
    end

    describe "GET new" do
      it "assigns a new feed as @feed" do
        get :new
        assigns(:feed).must_be_instance_of(Feed)
      end
    end

    describe "POST create" do
      context "when user does not signed in" do
        it "should redirect to signin path" do
          @controller.sign_out
          post :create, :feed => valid_attributes
          assert_redirected_to "/auth/twitter"
        end
      end

      describe "with valid params" do
        it "creates a new Feed" do
          before = Feed.count
          post :create, :feed => valid_attributes
          Feed.count.must_be_close_to(before, 1)
        end

        describe "duplicate feed" do
          it "should not create new feed" do
            post :create, :feed => valid_attributes
            before = Feed.count
            post :create, :feed => valid_attributes
            Feed.count.must_equal before
          end

          context "when other user's feeds are exist" do
            before (:each) do
              different_user = Factory(:user)
              @controller.sign_in(different_user)
              post :create, :feed => valid_attributes
            end

            it "should not create new feed" do
              @controller.sign_in(User.first)
              before = Feed.count
              post :create, :feed => valid_attributes
              Feed.count.must_equal before
            end

            it "should register to current_user" do
              @controller.sign_in(User.first)
              post :create, :feed => valid_attributes
              feed = Feed.find_by_url(valid_attributes[:url])
              feed.users.must_equal User.all.reverse
              @controller.current_user.feeds.must_equal [feed]
            end
          end
        end

        it "register feed to current user" do
          post :create, :feed => valid_attributes
          feed = Feed.find_by_url(valid_attributes[:url])
          feed.users.must_equal [@controller.current_user]
          @controller.current_user.feeds.must_equal [feed]
        end

        it "assigns a newly created feed as @feed" do
          post :create, :feed => valid_attributes
          assigns(:feed).must_be_instance_of(Feed)
          assigns(:feed).must_be :persisted?
        end

        it "redirects to the created feed" do
          post :create, :feed => valid_attributes
          assert_redirected_to(Feed.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved feed as @feed" do
          # Trigger the behavior that occurs when invalid params are submitted
          Feed.any_instance.expects(:save).returns(false)
          post :create, :feed => {}
          assigns(:feed).must_be_instance_of(Feed)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Feed.any_instance.expects(:save).returns(false)
          post :create, :feed => {}
          assert_template "new"
        end

        it "do not register feed to current user" do
          post :create, :feed => {}
          @controller.current_user.feeds.must_equal []
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested feed" do
        feed = Factory(:feed)
        before = Feed.count
        delete :destroy, :id => feed.id
        (Feed.count - before).must_equal -1
      end

      it "should remove user's feeds" do
        feed = Factory(:feed)
        feed.register_user(@controller.current_user)
        @controller.current_user.feeds.must_equal [feed]
        delete :destroy, :id => feed.id
        @controller.current_user.feeds.must_be :empty?
      end

      context "when another user subscribing the requested feed" do
        it "should not destroys the requested feed" do
          @different_user = Factory(:user)
          feed = Factory(:feed)
          feed.register_user(@different_user)
          feed.register_user(@user)
          before = Feed.count
          delete :destroy, :id => feed.id
          Feed.count.must_equal before
        end
      end

      it "redirects to the feeds list" do
        feed = Factory(:feed)
        delete :destroy, :id => feed.id
        assert_redirected_to(feeds_url)
      end
    end
  end

  context "when user does not signed in" do
    describe "GET index" do
      it "should redirect to signin path" do
        get :index
        assert_redirected_to "/auth/twitter"
      end
    end

    describe "GET show" do
      it "should redirect to signin path" do
        @controller.sign_out
        feed = Factory(:feed)
        get :show, :id => feed.id
        assert_redirected_to "/auth/twitter"
      end
    end

    describe "GET new" do
      it "should redirect to signin path" do
        @controller.sign_out
        get :new
        assert_redirected_to "/auth/twitter"
      end
    end
  end
end
