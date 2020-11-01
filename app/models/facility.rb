class Facility < ApplicationRecord
  attr_accessor :created_at_date, :updated_at_date
  has_many :relate_to_oils, class_name: "FacilityOil", inverse_of: :facility,
                            foreign_key: "facility_id", dependent: :destroy
  has_many :oils, through: :relate_to_oils
  has_many :constructions, class_name: "Construction", dependent: :destroy
  has_many :orders, class_name: "Order", dependent: :destroy
  accepts_nested_attributes_for :relate_to_oils
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true

  # search
  def self.search(params)
    name = "%#{params[:name]}%"
    created_at_date = params[:created_at_date]
    updated_at_date = params[:updated_at_date]
    if created_at_date.present?
      created_at = Date.new(params["created_at(1i)"].to_i, params["created_at(2i)"].to_i,
                            params["created_at(3i)"].to_i)
    end
    if updated_at_date.present?
      updated_at = Date.new(params["updated_at(1i)"].to_i, params["updated_at(2i)"].to_i,
                            params["updated_at(3i)"].to_i)
    end
    @facility = Facility.all
    @facility = @facility.where("name LIKE ?", name) if name.present?
    @facility = @facility.where("created_at >= ?", created_at) if created_at.present?
    @facility = @facility.where("updated_at >= ?", updated_at) if updated_at.present?
    @facility
  end
end
