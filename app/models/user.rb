# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  approved        :boolean          default(FALSE)
#  email_address   :string           not null
#  first_name      :string
#  is_active       :boolean          default(TRUE)
#  last_name       :string
#  password_digest :string           not null
#  personal_email  :string           not null
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

ROLES = { admin: "admin", principal: "principal", teacher: "teacher", student: "student" }.freeze

before_validation :generate_school_email, on: :create

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :personal_email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8, maximum: 20 }, if: :password_required?
  validates :role, inclusion: { in: ROLES.values }

  scope :approved, -> { where(approved: true) }

  before_create :auto_approve_principal

def auto_approve_principal
  self.approved = true if principal? || student?
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

  private

  def generate_school_email
    return if email_address.present?

    first_name_part = first_name.downcase.strip.gsub(/\s+/, "")
    last_name_part = last_name.downcase.strip.gsub(/\s+/, "")[0..2] # First 3 letters of last name
    school_domain = "#{role.downcase}.schoolname.edu"

    self.email_address = "#{first_name_part}.#{last_name_part}@#{school_domain}"
  end

  def password_required?
    new_record? || password.present?
  end
end
