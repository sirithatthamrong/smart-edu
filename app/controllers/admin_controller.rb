class AdminController < ApplicationController
  before_action :require_admin

  def scan_qr
    # This will render app/views/admin/scan_qr.html.erb
  end

  def checkin
    uid = params[:uid]

    student = Student.find_by(uid: uid)
    if student
      Attendance.create(student: student, timestamp: Time.current, user: current_user)
      message = "Student checked in successfully at #{Time.current.strftime('%H:%M:%S')}."
      respond_to do |format|
        format.json { render json: { success: true, message: message } }
        format.html { redirect_to admin_scan_qr_path, notice: message }
      end
    else
      message = "Student not found."
      respond_to do |format|
        format.json { render json: { success: false, message: message } }
        format.html { redirect_to admin_scan_qr_path, alert: message }
      end
    end
  end

  private

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Access denied."
    end
  end
end
