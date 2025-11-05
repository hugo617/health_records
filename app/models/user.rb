class User < ApplicationRecord
  self.table_name = "users"

  # 验证
  validates :username, presence: true
  validates :nickname, presence: true, uniqueness: true
  validates :phone, presence: true
  validates :password, presence: true

  # 状态枚举
  enum status: { disabled: 0, active: 1 }

  # 在创建时保证 create_time 有值（兼容不能设置 DB 默认的情况）
  before_create :ensure_create_time

  # 关联：用户有多个附件，级联删除由 DB 外键 and on_delete: :cascade 保证，
  # 这里也在应用层声明 dependent: :destroy（可选）
  has_many :file_records, class_name: 'FileRecord', foreign_key: 'user_id', dependent: :destroy

  private

  def ensure_create_time
    self.create_time ||= Time.current
  end
end
