require 'test_helper'

class RentLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rent_log = rent_logs(:one)
  end

  test "should get index" do
    get rent_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_rent_log_url
    assert_response :success
  end

  test "should create rent_log" do
    assert_difference('RentLog.count') do
      post rent_logs_url, params: { rent_log: {  } }
    end

    assert_redirected_to rent_log_url(RentLog.last)
  end

  test "should show rent_log" do
    get rent_log_url(@rent_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_rent_log_url(@rent_log)
    assert_response :success
  end

  test "should update rent_log" do
    patch rent_log_url(@rent_log), params: { rent_log: {  } }
    assert_redirected_to rent_log_url(@rent_log)
  end

  test "should destroy rent_log" do
    assert_difference('RentLog.count', -1) do
      delete rent_log_url(@rent_log)
    end

    assert_redirected_to rent_logs_url
  end
end
