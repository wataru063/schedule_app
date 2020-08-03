class Oil < ApplicationRecord
  has_many :relate_to_facilities, class_name: "FacilityOil",
                                  foreign_key: "oil_id", dependent: :destroy
  has_many :facilities, through: :relate_to_facilities
  has_many :constructions, class_name: "Construction"
  has_many :orders, class_name: "Order"
  validates :name, presence: true, uniqueness: true
end
