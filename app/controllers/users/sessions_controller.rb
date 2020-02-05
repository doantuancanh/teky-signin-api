# frozen_string_literal: true
require 'jwt'

class Users::SessionsController < Devise::SessionsController
  before_action :check_sign_in, except: :create
  skip_before_action :verify_signed_out_user, only: :destroy
  # before_action :authenticate_user!, only: :destroy
  # GET /resource/sign_in
  # def new
  #   super
  # end
  after_action :reset_session_token, only: :destroy
  # POST /resource/sign_in
  def create
    user = User.where(:email => params[:user][:email]).first
    if user && user.valid_password?(params[:user][:password])
      token = generate_token user
      render json: {token: token, status: :ok}, status: :ok
      return
    else
      render json: {message: 'Wrong username or password'}, status: 400
      return
    end
  end

  def change_password
    # if request.headers['Authorization'].present?
      # user = User.where(:session_token => request.headers['Authorization']).last
      if @user.valid_password?(params[:password]) && params[:new_password] == params[:renew_password]
        @user.update(password: params[:new_password])
        render json: {message: "Change password success"}, status: 200
      else
        render json: { message: "Something wrong! Try again"}, status: 400
      end
    # end
  end

  # DELETE /resource/sign_out
  def destroy
    @user.update(:session_token => '')
    render json: :ok, status: 200
  end

  private
  def generate_token user
    data = {
      iat: Time.now.to_i,
      exp: 1.weeks.from_now.to_i,
      sub: user.id
    }
    token = JWT.encode(data, 'secret', 'HS256')
    user.update(session_token: token)
    token
  end

  def user_params
    params.require(:user).permit :email, :password
  end
end
