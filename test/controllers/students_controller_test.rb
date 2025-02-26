require "test_helper"

class StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @classroom = Classroom.create!(grade_level: 5, class_id: "MATH101")
    @student = Student.first
    sign_in
  end

  test "should show student" do
    get student_url(@student)
    assert_response :success
  end

  test "should get new" do
    get new_student_url
    assert_response :success
  end

test "should create student" do
  user = User.create!(
    first_name: 'John',
    last_name: 'Doe',
    personal_email: "personal_#{SecureRandom.hex(4)}@gmail.com", # Ensure unique personal email
    role: 'student',
    password: 'securepassword'
  )

  assert_difference('Student.count') do
    post students_url, params: { student: {
      first_name: user.first_name,
      last_name: user.last_name,
      grade: 5,
      classroom_id: @classroom.id,
      student_email_address: user.email_address, # Backend will generate this
      parent_email_address: 'parent.doe@example.com'
    }}
  end

  assert_redirected_to student_url(Student.last)
end

  test "should get edit" do
    get edit_student_url(@student)
    assert_response :success
  end

  test "should update student" do
    patch student_url(@student), params: { student: { name: "newname", is_active: 1, grade: @student.grade, classroom_id: @student.classroom_id, student_email_address: @student.student_email_address, parent_email_address: @student.parent_email_address } }
    assert_redirected_to student_url(@student)
  end

  test "archive student after deletion" do
    delete student_url(@student)
    @student.reload
    assert_equal false, @student.is_active?, "Student was not archived"
    assert_redirected_to students_path
    assert_equal "#{@student.name} was archived successfully.", flash[:notice]
  end
end
