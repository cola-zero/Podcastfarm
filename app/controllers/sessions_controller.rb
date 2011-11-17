class SessionsController < ApplicationController
  include SessionsHelper
  def create
    auth = request.env['omniauth.auth']
    sign_in User.find_or_create_from_hash(auth)
    redirect_to '/'
  end
end
