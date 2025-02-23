class SignupController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    @user = User.new
  end

  def create
    ActiveRecord::Base.transaction do
      @user = User.new(user_params)

      # Ensure the email is generated before saving
      if @user.save
        flash[:notice] = "Account created successfully! Your login email is #{@user.email_address}"
        redirect_to login_path
      else
        flash[:alert] = @user.errors.full_messages.join(", ")
        render :new
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = "Error: #{e.message}"
    render :new
  end

  private

def user_params
  params.require(:user).permit(:first_name, :last_name, :personal_email, :password, :password_confirmation, :role)
end
end
