class PasswordResetsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email].downcase)
    if user
      user.send_password_reset
    else
      flash[:error] = "that e-mail is unknown to us"
      redirect_to new_password_reset_path
    end
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token(params[:id])
    if @user.password_reset_sent_at < 24.hours.ago
      flash[:error] = "Password reset has expired."
      redirect_to new_password_reset_path
    elsif @user.update_attributes(params[:user])
      flash[:success] = "Password has been reset!"
      redirect_to @user
    else
      render :edit
    end
  end

end
