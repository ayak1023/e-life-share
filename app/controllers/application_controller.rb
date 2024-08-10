class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:top, :about, :index]
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    mypage_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  add_flash_types :secondary, :success, :danger, :warning, :info, :light, :dark

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
