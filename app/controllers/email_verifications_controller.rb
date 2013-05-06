class EmailVerificationsController < ApplicationController
    
  def update
    @user = User.find_by_verification_token(params[:verification_token])
    if @user
      @user.verification_token = nil
      @user.status_event = :activate
      @user.save(validate: false)
      sign_in @user
      redirect_to @user
    else
      redirect_to root_path
    end
  end
end
