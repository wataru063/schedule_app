class Oil < ApplicationRecord
  has_many :relate_to_facilities, class_name:  "FacilityOil",
                                   foreign_key: "oil_id", dependent: :destroy
  has_many :facilities, through: :relate_to_facilities
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
end
