require "application_system_test_case"

class StudentsTest < ApplicationSystemTestCase
  def login
    visit new_session_url
    @user = users(:one)
    fill_in "email_address", with: @user.email_address
    fill_in "password", with: "password"
    click_on "Sign in"
    assert_selector "h2 span", text: "Dashboard"
  end

  setup do
    @student = students(:student_1)
    login
  end

  test "visiting the index" do
    visit students_url
    assert_selector "h2", text: "Students"
  end

  test "should create student" do
    visit students_url
    click_on "New student"
    fill_in "Name", with: "Harry"
    fill_in "Section", with: "3"
    fill_in "Grade", with: "B"
    click_on "Create Student"
    assert_text "Student was successfully created"
    assert_text "Harry" # Ensure the new student's name is displayed
  end

  test "should update student" do
    visit student_url(@student)
    click_on "Edit", match: :first
    fill_in "Name", with: "Harry"
    fill_in "Section", with: "5"
    fill_in "Grade", with: "B"
    click_on "Update Student"
    assert_text "Student was successfully updated"
    assert_text "Harry" # Ensure the updated name is displayed
    click_on "Back"
  end

  test "should archive student (destroy)" do
    visit student_url(@student)
    accept_alert do
      click_on "Delete", match: :first
    end
    @student.reload
    assert_equal true, @student.is_active
    assert_text "#{@student.name} was archived successfully."
  end
end
