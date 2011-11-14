# == Schema Information
#
# Table name: feeds
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  url         :string(255)     not null
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Feed do
  let(:feed) { Feed.new(attr) }
  let(:attr) { { :url => url } }
  let(:url)  { "file://#{URI.escape(File.join(File.dirname(File.expand_path(__FILE__, Dir.getwd)), "..", "fixtures", "feed.rss"))}" }
  let(:not_found_url) { "file://#{URI.escape(File.join(File.dirname(File.expand_path(__FILE__, Dir.getwd)), "..", "fixtures", "not_found.rss"))}" }

  it 'can be created' do
    feed.should_not be_nil
  end

  it "should be valid" do
    feed.should be_valid
  end

  context "invalid attribute" do
    context "when url is not present" do
      let(:url) { nil }
      it "should not be valid" do
        feed.should_not be_valid
      end
    end

    context "when url is 404" do
      let(:url) { not_found_url }
      it "should not create entry" do
        Feed.count.should == 0
      end
    end

    context "when url is duplicated" do
      it "should not save to db" do
        feed.save
        lambda{ Feed.create(attr) }.should change(Feed, :count).by(0)
      end
    end
  end

  describe "attribute validater" do
    context "url is valid" do
      let(:url) { "http://example.com/" }
      it "should be valid" do
        feed.send(:url_is_valid).should be_true
      end
    end
    context "url is not valid" do
      let(:url) { "htp://invadlid_url/" }
      it "should not be valid" do
        feed.should_not be_valid
      end
    end
  end

  describe "get_feed_infomation" do
    before(:each) do
      feed.send(:get_feed_infomation)
    end

    it "should set initial attributes" do
      feed.title.should == "Example Feed"
      feed.description.should == "This is test feed."
    end
    context "404 feed" do
      let(:url) { not_found_url }
      describe "title" do
        it "should be empty" do
          feed.title.should be_empty
        end
      end
      describe "description" do
        it "should be empty" do
          feed.description.should be_empty
        end
      end
    end
  end

  describe "callback methods" do
    it 'should set title and description' do
      feed.save
      feed.title.should == "Example Feed"
      feed.description == "This is test feed."
    end
  end
end
