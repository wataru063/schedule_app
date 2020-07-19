class Construction < ApplicationRecord
  attr_accessor :start_at_date, :end_at_date
  validates :name,     presence: true
  validates :status,   presence: true
  validates :oil_id,   presence: true
  validates :user_id,  presence: true
  validates :start_at, presence: true
  validates :end_at,   presence: true
  validates :category_id,   presence: true
  validates :start_at_date, presence: true
  validates :end_at_date,   presence: true
  # custom validation
  validate  :start_at_not_before_two_months_later
  validate  :end_date_not_before_start_at_date

  # custom validation definition
  def start_at_not_before_two_months_later
    if start_at_date.present? && start_at.present? && start_at < Time.current.since(2.month)
      errors.add(:start_at, "は2ヶ月後以降に設定してください")
    end
  end

  def end_date_not_before_start_at_date
    if start_at.present? && end_at.present? && end_at_date.present? && end_at < start_at
      errors.add(:end_at, "は工事開始日時より前に設定できません")
    end
  end
end
