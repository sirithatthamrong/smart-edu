class UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @pending_users = User.where(approved: false)
  end

  def approve
    user = User.find(params[:id])
    user.update(approved: true)
    flash[:notice] = "#{user.email_address} has been approved."
    redirect_to users_path
  end

  private

  def authenticate_admin!
    redirect_to root_path, alert: "Not authorized" unless current_user&.can_manage_teachers?
  end
end
