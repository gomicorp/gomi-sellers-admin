module HttpBasicAuth
  extend ActiveSupport::Concern

  def basic_admin_authenticate
    authenticate_or_request_with_http_basic do |username, password|
      @admin = Admin.find_by_email(username)
      @current_user ||= @admin if @admin&.valid_password?(password) # note. this is nullable
    end
  end

  def basic_console_authenticate
    authenticate_or_request_with_http_basic do |username, password|
      @current_user = User.managers.or(User.admins).find_by_email(username)
      @current_user&.valid_password?(password)
    end
  end

  def basic_auth_sign_out
    template_path = 'layouts/basic_auth/sign_out'
    render layout: false, template: template_path, status: :unauthorized and return
  end
end
