class UsersController < ApplicationController
  def show
  end

  def edit
    if @user.save
      flash[:notice] = "Welcome! You have signed up successfully."
    else
      render :root_path
    end
  end
end
