require "test_helper"

class BhksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bhks_index_url
    assert_response :success
  end
end
