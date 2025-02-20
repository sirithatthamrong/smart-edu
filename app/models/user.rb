# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  approved        :boolean          default(FALSE)
#  email_address   :string           not null
#  is_active       :boolean          default(TRUE)
#  password_digest :string           not null
#  role            :string           default("student")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  school_id       :integer
#
# Indexes
#
#  index_users_on_email_address  (email_address) UNIQUE
#  index_users_on_school_id      (school_id)
#
# Foreign Keys
#
#  school_id  (school_id => schools.id)
#
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8, maximum: 20 }, if: :password_required?

  ROLES = { admin: "admin", principal: "principal", teacher: "teacher", student: "student", system: "system" }.freeze
  validates :role, inclusion: { in: ROLES.values }

  scope :approved, -> { where(approved: true) }
  scope :pending_in_school, ->(school_id) { where(approved: false, school_id: school_id) }

  before_create :auto_approve_principal

  def auto_approve_principal
    self.approved = true if principal? || admin?
  end

  def can_manage_teachers?
    admin? || principal?
  end

  def admin?
    role == "admin"
  end

  def principal?
    role == "principal"
  end

  def teacher?
    role == "teacher"
  end

  def student?
    role == "student"
  end

  def system?
    role == "system"
  end

  private

  def password_required?
    new_record? || password.present?
  end

  def validate_student_email
    unless Student.exists?(student_email_address: email_address)
      errors.add(:email_address, "is not linked to any student in our records")
    end
  end
end
