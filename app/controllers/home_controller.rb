class HomeController < ApplicationController
  def index
    @users = User.all  # 获取所有用户数据
    @message = "用户列表"
  end
end
