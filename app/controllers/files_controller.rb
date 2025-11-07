class FilesController < ApplicationController
  before_action :set_file_record, only: [:show, :download]

  def index
    @files = FileRecord.all.order(upload_time: :desc)
  end

  def show
    # 渲染带有内嵌预览的 HTML 页面，iframe/src 指向 download 动作
  end

  def download
    # file_path 存储格式示例： /uploads/reports/gene_2025110501.pdf
    relative_path = @file_record.file_path.to_s.sub(%r{^/}, '')
    full_path = Rails.root.join('public', relative_path)

    unless File.exist?(full_path)
      render plain: "File not found: #{@file_record.file_path}", status: :not_found and return
    end

    # Determine content type dynamically (fall back to application/octet-stream)
    content_type = nil
    begin
      if defined?(Marcel)
        content_type = Marcel::MimeType.for(Pathname.new(full_path))
      end
    rescue StandardError
      content_type = nil
    end

    if content_type.blank?
      # Use Rack::Mime to map by extension as a fallback
      content_type = Rack::Mime.mime_type(File.extname(full_path).downcase, 'application/octet-stream')
    end

    # Allow caller to request 'attachment' for download; default to 'inline' for preview
    disposition = params[:disposition] == 'attachment' ? 'attachment' : 'inline'

    send_file full_path,
              filename: @file_record.file_name,
              type: content_type,
              disposition: disposition
  end

  private

  def set_file_record
    @file_record = FileRecord.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render plain: "FileRecord not found", status: :not_found
  end
end