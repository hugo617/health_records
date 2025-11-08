class SessionsController < ApplicationController
  layout :set_layout
  
  def new
    return redirect_to root_path if session[:user_id]
    render 'admin_new'  # 渲染管理端登录页面
  end

  def mobile_new
    return redirect_to root_path if session[:user_id]
    render 'mobile_new', layout: 'mobile'  # 使用移动端布局
  end

  def create
    # 处理用户名密码登录
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_path = session.delete(:return_to) || root_path
      respond_to do |format|
        format.html { redirect_to redirect_path, notice: '登录成功' }
        format.json { render json: { redirect_to: redirect_path } }
      end
    else
      respond_to do |format|
        format.html do
          flash.now[:alert] = '用户名或密码错误'
          render :new, status: :unprocessable_entity
        end
        format.json { render json: { error: '用户名或密码错误' }, status: :unprocessable_entity }
      end
    end
  end

  def mobile_login
    # 处理手机验证码登录
    phone = params[:phone]
    code = params[:code]

    # 验证手机号格式
    unless phone =~ /^1[3-9]\d{9}$/
      return render json: { error: '请输入正确的手机号' }, status: :unprocessable_entity
    end

    # 验证验证码（实际项目中需要替换为真实的验证逻辑）
    unless valid_code?(phone, code)
      return render json: { error: '验证码错误或已过期' }, status: :unprocessable_entity
    end

    # 查找或创建用户
    user = User.find_or_create_by(phone: phone) do |u|
      u.username = "user_#{phone[-4..-1]}"  # 使用手机号后4位作为用户名
      u.password = SecureRandom.hex(8)      # 生成随机密码
    end

    # 登录用户
    session[:user_id] = user.id

    # 重定向到之前尝试访问的页面或首页
    redirect_path = session.delete(:return_to) || root_path
    render json: { redirect_to: redirect_path }
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: '已成功退出'
  end

  private

  def set_layout
    if action_name == 'mobile_new'
      'mobile'
    else
      false  # 不使用布局，因为管理端登录页面包含完整的 HTML 结构
    end
  end

  def valid_code?(phone, code)
    # TODO: 实现真实的验证码验证逻辑
    # 示例：验证 Redis 中存储的验证码
    # stored_code = Rails.cache.read("verification_code:#{phone}")
    # return code.present? && code == stored_code
    
    # 开发环境下，使用固定验证码 "123456" 用于测试
    return true if Rails.env.development? && code == "123456"
    
    false
  end
end