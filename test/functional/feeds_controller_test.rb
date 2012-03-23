require 'test_helper'
SimpleCov.command_name 'test:functionals' if ENV["COVERAGE"]

describe FeedsController do

  tests FeedsController

  def valid_attributes
    { :url => "file://#{URI.escape(File.join(File.dirname(File.expand_path(__FILE__, Dir.getwd)), "..", "fixtures", "feed.rss"))}" }
  end

  def manager
    Podcastfarm::FeedManager
  end

  let(:user) { Factory(:user) }
  let(:feed) { Factory(:feed) }
  let(:different_user) { Factory(:user) }

  context "when user signed in" do
    before do
      @controller.sign_in(user)
    end

    describe "GET index" do
      it "assigns all feeds as @feeds" do
        manager.register_user(feed, user)
        get :index
        assigns(:feeds).must_equal([feed])
      end

      it "should not assign another user's feed in @feeds" do
        manager.register_user(feed, different_user)
        get :index
        assigns(:feeds).must_equal([])
      end
    end

    describe "GET show" do
      it "assigns the requested feed as @feed" do
        get :show, :id => feed.id
        assigns(:feed).must_equal(feed)
      end

      describe "entry association" do
        let(:entry) { Factory(:entry) }
        let(:another_entry) { Factory(:entry_in_another_feed)}

        it "should assign entries in this feed" do
          entry.feed_id.must_equal feed.id
          entry.feed_id.wont_equal nil
          get :show, :id => feed.id
          assigns(:entries).must_equal([entry])
        end

        it "should not assign entries in another feed" do
          another_entry.feed_id.wont_equal feed.id
          another_entry.feed_id.wont_equal nil
          get :show, :id => feed.id
          assigns(:entries).must_equal([])
        end
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
            before do
              @controller.sign_in(different_user)
              post :create, :feed => valid_attributes
            end

            it "should not create new feed" do
              @controller.sign_in(user)
              before = Feed.count
              post :create, :feed => valid_attributes
              Feed.count.must_equal before
            end

            it "should register to current_user" do
              @controller.sign_in(user)
              post :create, :feed => valid_attributes
              feed = Feed.find_by_url(valid_attributes[:url])
              feed.users.include?(different_user).must_equal true
              feed.users.include?(user).must_equal true
              different_user.feeds.include?(feed).must_equal true
              user.feeds.include?(feed).must_equal true
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

        it "should call update_feed method" do
          feed = Feed.new
          Podcastfarm::FeedManager.expects(:find_or_create_feed).returns(feed)
          Podcastfarm::FeedManager.expects(:register_user).returns([])
          feed.expects(:save).returns(true)
          feed.expects(:update_feed)
          post :create, :feed => valid_attributes
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
      before do
        manager.register_user(feed, @controller.current_user)
      end

      it "destroys the requested feed" do
        feed.users.count.must_equal 1
        before = Feed.count
        delete :destroy, :id => feed.id
        (Feed.count - before).must_equal -1
      end

      it "should remove user's feeds" do
        manager.register_user(feed, @controller.current_user)
        @controller.current_user.feeds.must_equal [feed]
        delete :destroy, :id => feed.id
        @controller.current_user.feeds.must_be :empty?
      end

      context "when another user subscribing the requested feed" do
        let(:defferent_user) { Factory(:user)}

        it "should not destroys the requested feed" do
          manager.register_user(feed, different_user)
          manager.register_user(feed, user)
          before = Feed.count
          delete :destroy, :id => feed.id
          Feed.count.must_equal before
        end
      end

      it "redirects to the feeds list" do
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
