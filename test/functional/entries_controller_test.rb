require 'test_helper'
SimpleCov.command_name 'test:functionals' if ENV["COVERAGE"]

class EntriesControllerTest < ActionController::TestCase
  setup do
    @entry = Factory(:entry)
  end

  test "should get index" do
    get :index
    assert_response :success
    assigns(:entries).wont_be_nil
  end

  test "should show entry" do
    get :show, id: @entry
    assert_response :success
  end
end
