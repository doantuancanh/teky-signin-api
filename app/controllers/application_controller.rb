class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  before_action :authenticate_user!, :unless => :custom_authenticate_user!
  before_action :forgery_protection_origin_check
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
    user_params.permit :email, :password
    end
  end

  def custom_authenticate_user!
    if request.headers['Authorization'].present?
      user = User.where(:session_token => request.headers['Authorization']).last
      if user 
        current_user = user
        return true
      else
      end
    end
    false
  end

  def check_sign_in
    @user = User.where(:session_token => request.headers['Authorization']).last
    if @user.blank?
      render json: { message: "You need sign in first" }, status: 400
      return
    end
    @user
  end
end
