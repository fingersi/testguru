class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(users_params)

    if @user.save
      redirect_to tests_path
    else
      render :new
    end
  end

  private

  def users_params
    params.require(:user).permit(:login, :email, :password, :password_confirmation)
  end
end
