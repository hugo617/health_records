class ReportsController < ApplicationController
  def index
    # 读取所有报告类型参数，按 sort 排序
    @report_params = Param.where(param_type: 'file_report').order(:sort)
  end

  # POST /reports/search
  def search
    name = params[:name].to_s.strip
    param_id = params[:param_id].to_i

    if name.blank?
      return render json: { error: '请输入用户名或昵称' }, status: :bad_request
    end

    user = User.where('nickname = ? OR username = ?', name, name).first
    unless user
      return render json: { error: "未查询到用户名或昵称为 #{ERB::Util.html_escape(name)} 的用户" }, status: :not_found
    end

    # 查询 files：通过 entity_param_rels (rel_type='file') 关联到 files.id
    files = FileRecord.joins("INNER JOIN entity_param_rels epr ON epr.entity_id = files.id")
                      .where("epr.param_id = ? AND epr.rel_type = 'file' AND files.user_id = ?", param_id, user.id)
                      .select('files.*')
                      .order(upload_time: :desc)

    if files.empty?
      return render json: { error: "未查询到该用户的报告（param_id=#{param_id}）" }, status: :not_found
    end

    html = render_to_string(partial: 'list', locals: { files: files, user: user })
    render json: { html: html }, status: :ok
  end
end