require 'test_helper'

class MoreListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @more_list = more_lists(:one)
  end

  test "should get index" do
    get more_lists_url
    assert_response :success
  end

  test "should get new" do
    get new_more_list_url
    assert_response :success
  end

  test "should create more_list" do
    assert_difference('MoreList.count') do
      post more_lists_url, params: { more_list: {  } }
    end

    assert_redirected_to more_list_url(MoreList.last)
  end

  test "should show more_list" do
    get more_list_url(@more_list)
    assert_response :success
  end

  test "should get edit" do
    get edit_more_list_url(@more_list)
    assert_response :success
  end

  test "should update more_list" do
    patch more_list_url(@more_list), params: { more_list: {  } }
    assert_redirected_to more_list_url(@more_list)
  end

  test "should destroy more_list" do
    assert_difference('MoreList.count', -1) do
      delete more_list_url(@more_list)
    end

    assert_redirected_to more_lists_url
  end
end
