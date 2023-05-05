require 'test_helper'

class UserLogsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_logs_index_url
    assert_response :success
  end

end
