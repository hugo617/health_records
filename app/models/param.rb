class Param < ApplicationRecord
  self.table_name = 'params'

  validates :param_type, presence: true
  validates :param_name, presence: true
  validates :param_code, presence: true, uniqueness: true

  # 可选：按 sort 排序的 scope
  scope :ordered, -> { order(:sort) }
end