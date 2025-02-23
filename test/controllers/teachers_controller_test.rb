require "test_helper"

class TeachersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get teachers_index_url
    assert_response :success
  end

  test "should get destroy" do
    get teachers_destroy_url
    assert_response :success
  end
end
