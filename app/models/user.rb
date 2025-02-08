# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  approved        :boolean          default(FALSE)
#  email_address   :string           not null
#  is_active       :boolean          default(TRUE)
#  password_digest :string           not null
#  role            :string           default("teacher")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email_address  (email_address) UNIQUE
#
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8, maximum: 20 }

  ROLES = { admin: "admin", principal: "principal", teacher: "teacher" }.freeze
  validates :role, inclusion: { in: ROLES.values }

  scope :approved, -> { where(approved: true) }

  before_create :auto_approve_principal

  def auto_approve_principal
    self.approved = true if role == "principal" || role == "admin"
  end

  def can_manage_teachers?
    role == "principal" || role == "admin"
  end
end
