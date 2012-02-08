require 'test_helper'

describe FeedsController do

  tests FeedsController

  describe "routing" do

    it "routes to #index" do
      assert_routing( { :path => "/feeds", :method => :get}, { :controller => "feeds", :action => "index" })
    end

    it "routes to #new" do
      assert_routing( { :path => "/feeds/new", :method => :get}, { :controller => "feeds", :action => "new" })
    end

    it "routes to #show" do
      assert_routing( { :path => "/feeds/1", :method => :get}, { :controller => "feeds", :action => "show", :id => "1" })
    end

    it "routes to #create" do
      assert_routing( { :path => "/feeds", :method => :post}, { :controller => "feeds", :action => "create"})
    end

    it "routes to #destroy" do
      assert_routing( { :path => "/feeds/1", :method => "delete"}, { :controller => "feeds", :action => "destroy", :id => "1"})
    end

  end
end
