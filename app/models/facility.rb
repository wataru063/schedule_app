class Facility < ApplicationRecord
  has_many :relate_to_oils, class_name: "FacilityOil", inverse_of: :facility,
                            foreign_key: "facility_id"
  has_many :oils, through: :relate_to_oils
  has_many :constructions, class_name: "Construction"
  has_many :orders, class_name: "Order"
  accepts_nested_attributes_for :relate_to_oils
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true

  def relate(oil)
    oils << oil
  end

  def break_off(oil)
    relate_to_oils.find_by(oil_id: oil.id).destroy
  end

  def oils?(oil)
    oils.include?(oil)
  end
end
