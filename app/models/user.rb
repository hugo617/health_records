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

  private

  def ensure_create_time
    self.create_time ||= Time.current
  end
end
