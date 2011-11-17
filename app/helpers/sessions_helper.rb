module SessionsHelper
  def current_user
    return @current_user || User.find_by_id(session[:user_id])
  end

  def sign_in(user)
    return false if user == false
    @current_user = user
    session[:user_id] = @current_user.id
  end

  def signed_in?
    return !!current_user
  end

  def sign_out
    @current_user = nil
    session[:user_id] = nil
  end
end
