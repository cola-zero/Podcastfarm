require 'test_no_rails_helper'
SimpleCov.command_name 'test:units' if ENV["COVERAGE"]
require 'entry_methods'

class DummyEntryClass
  include Podcastfarm::EntryMethods
  attr_accessor :title, :description, :guid, \
                :enc_url, :enc_length, :enc_type
end

describe "EntryMethods" do

  subject { DummyEntryClass.new }

  describe "get_entry_information" do

    let(:parser) { mock }
    let(:entry)   { DummyEntryClass.new }

    it "must respond to 'get_entry_information'" do
      subject.must_respond_to(:get_entry_information)
    end

    def act_as_get_entry_information
      parser.expects(:title).returns("Ep. #1")
      parser.expects(:summary).returns("This is #1.")
      parser.expects(:id).returns("asdfg")
      parser.expects(:enc_url).returns("http://www.example.com/ep1.mp4")
      parser.expects(:enc_length).returns("123456")
      parser.expects(:enc_type).returns("video/mp4")
      entry.expects(:save).returns(true)
    end

    it "must return true" do
      act_as_get_entry_information
      entry.get_entry_information(parser).must_equal true
    end

    it "must set title" do
      act_as_get_entry_information
      entry.get_entry_information(parser)
      entry.title.must_equal "Ep. #1"
    end

    it "must set description" do
      act_as_get_entry_information
      entry.get_entry_information(parser)
      entry.description.must_equal "This is #1."
    end

    it "must set guid" do
      act_as_get_entry_information
      entry.get_entry_information(parser)
      entry.guid.must_equal "asdfg"
    end

    it "must set enclosure url" do
      act_as_get_entry_information
      entry.get_entry_information(parser)
      entry.enc_url.must_equal "http://www.example.com/ep1.mp4"
    end

    it "must set enclosure length" do
      act_as_get_entry_information
      entry.get_entry_information(parser)
      entry.enc_length.must_equal "123456"
    end
    it "must set enclosure type" do
      act_as_get_entry_information
      entry.get_entry_information(parser)
      entry.enc_type.must_equal "video/mp4"
    end
  end
end
