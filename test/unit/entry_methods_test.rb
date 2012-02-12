require 'test_no_rails_helper'
SimpleCov.command_name 'test:units' if ENV["COVERAGE"]
require 'entry_methods'

class DummyEntryClass
  include Podcastfarm::EntryMethods
  attr_accessor :title, :description, :guid
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
      parser.expects(:description).returns("This is #1.")
      parser.expects(:id).returns("asdfg")
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
  end
end
