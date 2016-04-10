class SessionsController < ApplicationController
  def new
    @logged_in_user = User.new
  end

  def create
    @logged_in_user = User.find_by(name: params[:name])
    if @logged_in_user.nil?
      @logged_in_user = User.new
      @notice = 'That user does not exist'
      render :new
    else
      log_in_user(@logged_in_user)
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private

  def log_in_user(user)
    if user.password == params[:password]
      @logged_in_user = user
      session[:user_id] = user.id
      redirect_to user
    else
      @logged_in_user = User.new
      @notice = 'Invalid password'
      render :new
    end
  end
end
