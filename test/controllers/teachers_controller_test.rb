require "test_helper"

class TeachersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email_address: "admin@test.com", password: "password123", role: "admin", approved: true, school_id: 1)
    post session_path, params: { email_address: @user.email_address, password: "password123" }
  end

  test "should get index" do
    get teachers_path
    assert_response :success
  end

  test "should destroy teacher" do
    teacher = User.create!(email_address: "teacher@test.com", password: "password123", role: "teacher", approved: true, school_id: @user.school_id)
    assert_difference("User.count", -1) do
      delete teacher_path(teacher)
    end

    assert_redirected_to teachers_path
  end
end
