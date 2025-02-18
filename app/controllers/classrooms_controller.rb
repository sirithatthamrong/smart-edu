class ClassroomsController < ApplicationController
  before_action :set_classroom, only: [ :show, :grading ]

  # Show action for displaying classroom details and students
  def show
    # Find the classroom by its ID
    @classroom = Classroom.find(params[:id])

    # Ensure that only students in this classroom and of the correct grade level are displayed
    @students = @classroom.students.where(grade: @classroom.grade_level).order(:name)
  end


  # Grading action for displaying students and their grades
  def grading
    @classroom = Classroom.find(params[:id])
    @grades = Student.distinct.where.not(grade: nil).pluck(:grade).compact.sort
    @students_by_grade = @grades.map do |grade|
      {
        grade: grade,
        students: @classroom.students.where(grade: grade).where.not(grade: nil)
      }
    end
  end

  def by_grade
    @classroom = Classroom.first
    @grade = params[:grade]  # Ensure @grade is set from params

    if @grade.blank?
      flash[:alert] = "Grade is missing."
      redirect_to classrooms_path and return
    end

    Rails.logger.debug "DEBUG: is checking grade"   # Check if grade is properly set

    @classrooms = Classroom.where("grade_level LIKE ?", "#{@grade}%").order(:class_id)

    Rails.logger.debug "DEBUG: @grade = #{@grade}"   # Check if grade is properly set
    Rails.logger.debug "DEBUG: @classrooms = #{@classrooms}" # Check fetched classrooms
  end


  private

  # This method is called before both show and grading actions to find the classroom
  def set_classroom
    @classroom = Classroom.first
  end
  def grade_level
    @classroom = Classroom.find(params[:id])
    @students_by_grade = @classroom.students.group_by(&:grade)
  end
end
