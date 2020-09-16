class FacilityOil < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :facility, class_name: "Facility"
  belongs_to :oil, class_name: "Oil"
  validates  :oil_id, presence: true
  validates  :facility_id, uniqueness: { :scope => :oil_id }
end
