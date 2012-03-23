class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery

  def authenticate
    redirect_to "/auth/twitter" unless signed_in?
  end

  before_filter :password_protected if Rails.env.staging?

  private
  def password_protected
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['STAGING_BASIC_AUTH_USERNAME'] &&
        password == ENV['STAGING_BASIC_AUTH_PASSWORD']
    end
  end
end
