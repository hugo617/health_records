module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
    helper_method :user_signed_in?
  end

  private

  def authenticate_user!
    unless user_signed_in?
      # 存储尝试访问的原始URL，以便登录后重定向
      store_location
      redirect_to mobile_login_path, alert: "请先登录"
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    !!current_user
  end

  def store_location
    # 不存储登录相关的路径
    return if request.path.match?(/\A\/(login|mobile_login|logout)/)
    session[:return_to] = request.fullpath if request.get?
  end

  def redirect_back_or_default(default = root_path)
    redirect_to(session.delete(:return_to) || default)
  end
end