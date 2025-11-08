class HomeController < ApplicationController
  before_action :redirect_to_login, only: [:index]
  
  def index
    @users = User.all  # 获取所有用户数据
    @message = "用户列表"
  end

  private

  def redirect_to_login
    unless session[:user_id]
      session[:return_to] = request.path
      redirect_to mobile_login_path, alert: "请先登录"
    end
  end
end
