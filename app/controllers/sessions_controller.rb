class SessionsController < ApplicationController
  include ApplicationHelper
  def create
    auth = request.env['omniauth.auth']
    sign_in User.find_or_create_from_hash(auth)
    if signed_in?
      flash[:notice] = "Sign in."
    else
      flash[:notice] = "Not Signed in."
    end
      redirect_to '/'
  end

  def destroy
    sign_out
    flash[:notice] = "Signed out."
    redirect_to '/'
  end

  def failure
    flash[:notice] = params[:message]
    redirect_to '/'
  end
end
