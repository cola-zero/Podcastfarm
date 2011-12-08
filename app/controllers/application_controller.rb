class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery

  def authenticate
    redirect_to "/auth/twitter" unless signed_in?
  end

end
