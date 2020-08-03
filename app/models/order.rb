class Order < ApplicationRecord
  attr_accessor :arrive_at_date
  belongs_to :facility, class_name: "Facility", optional: true
  belongs_to :oil, class_name: "Oil", optional: true
  belongs_to :user, class_name: "User", optional: true
  validates  :name,     presence: true
  validates  :shipment, presence: true
  validates  :quantity, presence: true
  validates  :company_name, presence: true
  validates  :facility_id,  presence: true
  validates  :oil_id,    presence: true
  validates  :user_id,   presence: true
  validates  :arrive_at, presence: true
  validates  :arrive_at_date, presence: true
  validate   :unit_not_nil
  validate   :arrive_at_not_be_set_in_the_past
  validate   :combination_of_arrive_at_and_facility_not_be_duplicate
  validate   :combination_of_arrive_at_and_facility_not_overlap_with_construction

  def unit_not_nil
    if quantity.present? && unit.blank?
      errors.add(:quantity, "を入力してください")
    end
  end

  def arrive_at_not_be_set_in_the_past
    if arrive_at_date.present? && arrive_at.present? && arrive_at < Time.current.tomorrow.midnight
      errors.add(:arrive_at, "は翌日以降に設定してください")
    end
  end

  def combination_of_arrive_at_and_facility_not_be_duplicate
    if arrive_at_date.present? && arrive_at.present? && facility_id.present?
      if Order.find_by(arrive_at: arrive_at, facility_id: facility_id).present?
        errors.add(:facility_id, "：#{Facility.find(facility_id).name}の
        #{arrive_at.strftime("%Y/%m/%d/%H:%M")} には他のオーダーが入っています")
      end
    end
  end

  def combination_of_arrive_at_and_facility_not_overlap_with_construction
    constructions = Construction.where(oil_id: oil_id) if oil_id.present?
    if arrive_at_date.present? && arrive_at.present? && constructions.present?
      constructions.each do |c|
        if c.start_at < arrive_at && arrive_at < c.end_at
          errors.add(:facility_id, "：#{Facility.find(facility_id).name}の
                                   #{arrive_at.strftime("%Y/%m/%d/%H:%M")}
                                   は工事(#{c.name}, 他#{constructions.count - 1}件)による出荷制約があります")
        end
      end
    end
  end

  def self.search(params)
    ship_name = params[:name]
    shipment = params[:shipment]
    facility_id = params[:facility_id]
    oil_id = params[:oil_id]
    arrive_at_date = params[:arrive_at_date]
    company_name = params[:company_name]
    if arrive_at_date.present?
      arrive_at = Date.new(params["arrive_at(1i)"].to_i, params["arrive_at(2i)"].to_i,
                           params["arrive_at(3i)"].to_i)
    end
    @order = Order.all
    @order = @order.where(name: ship_name) if ship_name.present?
    @order = @order.where(shipment: shipment) if shipment.present?
    @order = @order.where(facility_id: facility_id) if facility_id.present?
    @order = @order.where(company_name: company_name) if company_name.present?
    @order = @order.where(oil_id: oil_id) if oil_id.present?
    @order = @order.where("arrive_at >= ?", arrive_at) if arrive_at.present?
    @order
  end
end
