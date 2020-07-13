class ApplicationController < ActionController::Base
  include ActAsHelper
  include HttpBasicAuth

  act_as_helper :current_user, :basic_admin_authenticate
  helper_method :current_country
  helper_method :current_currency

  private

  def set_download_filename(filename)
    headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
  end

  def current_country
    @current_country ||= Country.at(ENV['APP_COUNTRY'])
  end

  def current_currency
    @current_currency ||= Money::Currency.wrap(current_country.iso_code)
  end
end
