class ApplicationController < ActionController::Base
  include Authentication

  before_action :set_current_user

  private

  # def start_new_session_for(user)
  #   user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
  #     Current.session = session
  #     cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
  #   end
  # end

  def set_current_user
    if Current.session
      @current_user = Current.session.user
      Rails.logger.info "DEBUG: Current user = #{@current_user&.email_address}"
    else
      Rails.logger.info "DEBUG: No active session"
    end
  end

  helper_method :current_user

  def current_user
    @current_user
  end
end
