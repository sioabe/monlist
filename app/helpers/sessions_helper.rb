module SessionsHelper
  def current_user
    @current_user ||= User.find_by(id:session[:user_id])
    #current_userにすでに現ユーザーがログインしていれば何もせず、
    #していなければ、User.findでログインユーザーを取得。そして@current_userに代入
  end
  def logged_in?
    !!current_user
  end
end
