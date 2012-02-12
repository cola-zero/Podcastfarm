require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  setup do
    @item = Factory(:item)
  end

  test "should get index" do
    get :index
    assert_response :success
    assigns(:items).wont_be_nil
  end

  test "should show item" do
    get :show, id: @item
    assert_response :success
  end
end
