require 'spec_helper'

describe "feeds/index" do
  before(:each) do
    assign(:feeds, [
      stub_model(Feed),
      stub_model(Feed)
    ])
  end

  it "renders a list of feeds" do
    render
  end
end
