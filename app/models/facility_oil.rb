class FacilityOil < ApplicationRecord
  belongs_to :facility, class_name: "Facility"
  belongs_to :oil, class_name: "Oil"
  validates  :oil_id, presence: true

  def combination_not_be_duplicated
    if oil_id.present? && start_at.present? && start_at < Time.current.since(2.month)
      errors.add(:start_at, "は2ヶ月後以降に設定してください")
    end
  end
end
