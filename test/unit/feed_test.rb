# == Schema Information
#
# Table name: feeds
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  url         :string(255)
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'test_helper'

describe Feed do

  let(:feed) { Feed.new() }
  let(:attr) { { :url => url } }
  let(:url)  { "file://#{URI.escape(File.join(File.dirname(File.expand_path(__FILE__, Dir.getwd)), "..", "fixtures", "feed.rss"))}" }
  let(:not_found_url) { "file://#{URI.escape(File.join(File.dirname(File.expand_path(__FILE__, Dir.getwd)), "..", "fixtures", "not_found.rss"))}" }

  before do
    feed.url = url
  end

  it 'can be created' do
    feed.wont_equal nil
  end

  it "should be valid" do
    feed.must_be :valid?
  end

  context "invalid attribute" do
    context "when url is not present" do
      let(:url) { nil }
      it "should not be valid" do
        feed.wont_be :valid?
      end
    end

    context "when url is duplicated" do
      it "should not save to db" do
        feed.save
        before = Feed.count
        second_feed = Feed.new
        second_feed.url = url
        second_feed.save
        Feed.count.must_equal(before)
      end
    end
  end

  describe "attribute validater" do
    context "url is valid" do
      let(:url) { "http://example.com/" }
      it "should be valid" do
        feed.must_be :valid?
      end
    end
    context "url is not valid" do
      let(:url) { "htp://invadlid_url/" }
      it "should not be valid" do
        feed.wont_be :valid?
      end
      context "when url has no scheme" do
        let(:url) { "invalid_url" }
        it "should not be valid" do
          feed.wont_be :valid?
        end
      end
    end
  end

  describe "user association" do
    subject { feed }
    it "must_respond_to(:users)" do
      subject.must_respond_to(:users)
    end
  end
end
