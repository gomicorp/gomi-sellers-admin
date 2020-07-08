class ApplicationController < ActionController::Base
  include ActAsHelper
  include HttpBasicAuth

  act_as_helper :current_user, :basic_admin_authenticate
end
