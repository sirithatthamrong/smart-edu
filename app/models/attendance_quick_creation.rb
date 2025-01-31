class AttendanceQuickCreation < ActiveModel
  belongs_to :student
  validates :student_id, presence: true
end
