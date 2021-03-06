class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def index
    if current_user.admin?
      @users = User.paginate(page: params[:page])
    else
      @users = User.with_status(:active).paginate(page: params[:page])
    end
  end

  def new
    redirect_to(root_path) if signed_in?
    @user = User.new
  end

  def destroy
    user = User.find(params[:id])
    if user.admin? and current_user?(user)
      flash[:notice] = "You cannot destroy yourself"
    else
      user.destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_url
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])

    redirect_to(root_path) if @user.inactive?
  end

  def create
    redirect_to(root_path) if signed_in?
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      UserMailer.signup_confirmation(@user).deliver
      render 'verification_step'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile udpated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
