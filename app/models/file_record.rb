class FileRecord < ApplicationRecord
  self.table_name = 'files'

  belongs_to :user

  validates :file_name, :file_path, :file_size, presence: true

  # 避免与 AR 内置方法冲突：使用 inactive/active 或 disabled/active
  enum file_status: { inactive: 0, active: 1 }

  before_create :ensure_upload_time

  private

  def ensure_upload_time
    self.upload_time ||= Time.current
  end
end