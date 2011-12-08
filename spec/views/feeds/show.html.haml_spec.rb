require 'spec_helper'

describe "feeds/show.html.haml" do
  before(:each) do
    @feed = assign(:feed, stub_model(Feed))
  end

  it "renders attributes in <p>" do
    render
  end
end
