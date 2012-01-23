require 'spec_helper'

describe "feeds/new" do
  before(:each) do
    assign(:feed, stub_model(Feed).as_new_record)
  end

  it "renders new feed form" do
    render

    assert_select "form", :action => feeds_path, :method => "post" do
      assert_select "div", :class => 'actions' do
        assert_select "label", :for => "feed_url"
        assert_select "input", :id => "feed_url", :name => "feed[url]"
        assert_select "input", :name => "commit", :type => "submit"
      end
    end
  end
end
