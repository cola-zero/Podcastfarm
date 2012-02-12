require 'test_no_rails_helper'
require 'item_methods'

class DummyItemClass
  include Podcastfarm::ItemMethods
  attr_accessor :title, :description
end

describe "ItemMethods" do

  subject { DummyItemClass.new }

  describe "get_item_information" do

    let(:parser) { mock }
    let(:item)   { DummyItemClass.new }

    it "must respond to 'get_item_information'" do
      subject.must_respond_to(:get_item_information)
    end

    def act_as_get_item_information
      parser.expects(:title).returns("Ep. #1")
      parser.expects(:description).returns("This is #1.")
    end

    it "must set title" do
      act_as_get_item_information
      item.get_item_information(parser)
      item.title.must_equal "Ep. #1"
    end

    it "must set description" do
      act_as_get_item_information
      item.get_item_information(parser)
      item.description.must_equal "This is #1."
    end
  end
end
