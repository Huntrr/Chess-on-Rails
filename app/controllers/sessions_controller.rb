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
    elsif @logged_in_user.password == params[:password]
      session[:user_id] = @logged_in_user.id
      redirect_to @logged_in_user
    else
      @notice = 'Invalid password'
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
