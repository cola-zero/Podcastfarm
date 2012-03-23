# == Schema Information
#
# Table name: entries
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :string(255)
#  feed_id     :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  guid        :string(255)
#  enc_url     :string(255)
#  enc_length  :integer
#  enc_type    :string(255)
#

require 'test_helper'
SimpleCov.command_name 'test:units' if ENV["COVERAGE"]

describe Entry do
  subject { Entry.new }

  describe "attributes" do
    let (:attr) { {
        :title => 'Example',
        :description => "foo bar",
        :enc_url => 'http://www.example.com/ep1.mp4',
        :enc_length => 123456,
        :enc_type => 'video/mp4'
      } }

    it "must be valid" do
      subject.must_be :valid?
    end

    it "must not allow mass asignment" do
      lambda{ subject.update_attributes(attr)}.
        must_raise(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "feed association" do
    it "must respond to feed" do
      subject.must_respond_to(:feed)
    end
  end

  describe "in_this_feed scope" do
    it "must respond to in_this_feed method" do
      Entry.must_respond_to(:in_this_feed)
    end
  end

  describe "find_from_parser scope" do
    it "must respond to find_from_parser method" do
      Entry.must_respond_to(:find_from_parser)
    end
  end
end
