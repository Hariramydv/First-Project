class ApplicationController < ActionController::Base 
  
  include Pagy::Backend
  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
     user_params.permit(:name, :pincode,:mobile_no, :email, :password, :password_confirmation, :image)
     end

     devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:name, :pincode, :mobile_no, :email, :password, :current_password, :image)
      end
    end



  protected
  def after_sign_out_path(resource_or_scope)
    redirect_to root_path
  end
end
