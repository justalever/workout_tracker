class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true, except: :sign_in # devise bug making this all weird currently
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_to_subdomain

  private

  def redirect_to_subdomain # redirects to subdomain on signup
    return if self.is_a?(DeviseController)
    if current_user.present? && request.subdomain != current_user.subdomain
      redirect_to workouts_url(subdomain: current_user.subdomain)
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    root_url(subdomain: resource_or_scope.subdomain)
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :subdomain])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :subdomain])
    end
end
