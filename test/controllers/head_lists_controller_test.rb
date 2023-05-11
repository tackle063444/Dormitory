require 'test_helper'

class HeadListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @head_list = head_lists(:one)
  end

  test "should get index" do
    get head_lists_url
    assert_response :success
  end

  test "should get new" do
    get new_head_list_url
    assert_response :success
  end

  test "should create head_list" do
    assert_difference('HeadList.count') do
      post head_lists_url, params: { head_list: {  } }
    end

    assert_redirected_to head_list_url(HeadList.last)
  end

  test "should show head_list" do
    get head_list_url(@head_list)
    assert_response :success
  end

  test "should get edit" do
    get edit_head_list_url(@head_list)
    assert_response :success
  end

  test "should update head_list" do
    patch head_list_url(@head_list), params: { head_list: {  } }
    assert_redirected_to head_list_url(@head_list)
  end

  test "should destroy head_list" do
    assert_difference('HeadList.count', -1) do
      delete head_list_url(@head_list)
    end

    assert_redirected_to head_lists_url
  end
end
